//
//  PushNotificationsViewModel.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine
import CancelBag

class PushNotificationsViewModel: BaseViewModel {
    
    let coordinator: Coordinator
    private let alarmUseCase: AlarmUseCaseDelegate = AlarmUseCase(alarmInterface: AlarmRepository())
    
    @Published var permission = UserDefaults().bool(forKey: "alarmPermission")
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        bind()
    }
    
    func bind() {
        
        $permission.sink { permission in
            UserDefaults().set(permission, forKey: "alarmPermission")
            self.alarmUseCase.toggleAlarmPermission(isPermission: permission)
        }
        .cancel(with: cancelBag)
    }
    
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func toggleAlarmPermssion(isPermission: Bool) {
        alarmUseCase.toggleAlarmPermission(isPermission: isPermission)
    }
    
}
