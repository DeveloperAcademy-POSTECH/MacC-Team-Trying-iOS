//
//  AlarmUseCase.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

protocol AlarmUseCaseDelegate: AnyObject {
    func fetchAlarms() -> AnyPublisher<[AlarmEntity], Error>
    func readAlarm(id: Int)
    func removeAllAlarms() async throws -> Bool
    func toggleAlarmPermission(isPermission: Bool)
    func deleteAlarm(id: Int) async throws -> Bool
}

class AlarmUseCase: AlarmUseCaseDelegate {
    
    func fetchAlarms() -> AnyPublisher<[AlarmEntity], Error> {
        alarmInterface.fetchAlarms()
    }
    
    func readAlarm(id: Int) {
        alarmInterface.readAlarm(id: id)
    }
    
    func removeAllAlarms() async throws -> Bool {
        return try await alarmInterface.removeAllAlarms()
    }
    
    func toggleAlarmPermission(isPermission: Bool) {
        alarmInterface.toggleAlarmPermission(isPermission: isPermission)
    }
    
    private let alarmInterface: AlarmInterface
    
    func deleteAlarm(id: Int) async throws -> Bool {
        return try await alarmInterface.deleteAlarm(id: id)
    }
    
    init(alarmInterface: AlarmInterface) {
        self.alarmInterface = alarmInterface
    }
    
}
