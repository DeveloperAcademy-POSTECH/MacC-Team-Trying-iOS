//
//  AlarmRepository.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine
//TODO 계속받아오기?
class AlarmRepository: AlarmInterface {
    
    private let alarmAPI: AlarmAPI
    
    init(alarmAPI: AlarmAPI = AlarmAPI()) {
        self.alarmAPI = alarmAPI
    }
    
    private func getLeftTime(time: String?) -> String {
        let format = DateFormatter()
        format.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let currentDateString = format.string(from: Date())
        if  let time = time,
            let startTime = format.date(from: time)?.addingTimeInterval(60 * 60 * 18),
            let endTime = format.date(from: currentDateString)?.addingTimeInterval(60 * 60 * 9) {
            return getTimeDiff(startTime: startTime, endTime: endTime)
        } else {
            return "-"
        }
    }
    
    private func getTimeDiff(startTime: Date, endTime: Date) -> String {
        let originTime = Int(endTime.timeIntervalSince(startTime))
        let time = Int(endTime.timeIntervalSince(startTime)) / 3600
        switch time {
        case 0:
            let min = originTime / 60
            return min != 0 ? "\(min)분 전" : "방금전"
        case 1..<24:
            return "\(originTime / 3600)시간 전"
        default:
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
            let str = formatter.string(from: startTime.addingTimeInterval(-60 * 60 * 9))
            let date = str.split(separator: " ")[0].split(separator: "-")
            let month = date[1]
            let day = date[2]
            return "\(month)월 \(day)일"
        }
    }
        
    private func getTwoLinesDescription(type: AlarmType, description: String?) -> String {
        guard let description = description else { return "" }
        switch type {
        case .new:
            return description.replacingOccurrences(of: "] ", with: "]\n")
        case .tommorow:
            return description.replacingOccurrences(of: "! ", with: "!\n")
//            return description
        case .arrive:
            return description.replacingOccurrences(of: "~ ", with: "~\n")
        }
    }
    
    func fetchAlarms() -> AnyPublisher<[AlarmEntity], Error> {
        return alarmAPI.getAlarms(type: .fetch)
            .map { res -> [AlarmEntity] in
                return self.getAlarms(alarmResponse: res)
            }
            .eraseToAnyPublisher()
    }
    
    func checkAlarm(id: Int) {
        alarmAPI.checkAlarm(type: .check, id: id)
    }
    
    private func getAlarms(alarmResponse: AlarmResponse) -> [AlarmEntity] {
        let dtos = alarmResponse.notifications
        var type: AlarmType = .arrive
        
        return dtos.map { dto -> AlarmEntity in
            switch dto.title {
            case "새로운 계획":
                type = .new
            case "데이트 D-day":
                type = .tommorow
            case "후기 도착":
                type = .arrive
            default:
                type = .new
            }
            return .init(
                type: type,
                id: dto.notificationID,
                title: dto.title,
                description: getTwoLinesDescription(type: type, description: dto.body),
                leftTimeString: getLeftTime(time: dto.createdDate),
                target: dto.target ?? "",
                targetId: dto.targetID ?? 0,
                checked: dto.checked
            )
        }
    }
    
    func readAlarm(id: Int) {
        alarmAPI.checkAlarm(type: .check, id: id)
    }

    func removeAllAlarms() {
        alarmAPI.removeAllAlarms(type: .delete)
    }
    
    func toggleAlarmPermission(isPermission: Bool) {
        alarmAPI.toggleAlarmPermission(type: .togglePermission, isPermission: isPermission)
    }
    
}
