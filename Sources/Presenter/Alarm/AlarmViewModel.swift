//
//  AlarmViewModel.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

class AlarmViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
    
    func popToRootViewController() {
        guard let coordinator = coordinator as? goToRootViewControllerDelegate else { return }
        coordinator.popToRootViewController()
    }
    
    func pushToLogViewController() {
        guard let coordinator = coordinator as? AlarmViewCoordinatingInAlarmViewCoordinating else { return }
        coordinator.goToLogView()
    }
    
}

protocol AlarmViewCoordinatingInAlarmViewCoordinating {
    func goToLogView()
}
