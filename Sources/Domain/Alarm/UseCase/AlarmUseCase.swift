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
    func removeAllAlarms()
    func toggleAlarmPermission(isPermission: Bool)
}

class AlarmUseCase: AlarmUseCaseDelegate {
    
    func fetchAlarms() -> AnyPublisher<[AlarmEntity], Error> {
        alarmInterface.fetchAlarms()
    }
    
    func readAlarm(id: Int) {
        alarmInterface.readAlarm(id: id)
    }
    
    func removeAllAlarms() {
        alarmInterface.removeAllAlarms()
    }
    
    func toggleAlarmPermission(isPermission: Bool) {
        alarmInterface.toggleAlarmPermission(isPermission: isPermission)
    }
    
    private let alarmInterface: AlarmInterface
    
    init(alarmInterface: AlarmInterface) {
        self.alarmInterface = alarmInterface
    }
    
}
