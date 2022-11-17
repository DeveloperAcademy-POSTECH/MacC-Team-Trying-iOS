//
//  AlarmViewModel.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine
import CancelBag

protocol AlarmViewCoordinatingInAlarmViewCoordinating {
    func goToLogView()
}

class AlarmViewModel: BaseViewModel {
    
    let alarmUseCase: AlarmUseCaseDelegate = AlarmUseCase(alarmInterface: AlarmRepository())
    var coordinator: Coordinator
    
    @Published var alarms: [AlarmEntity] = []
    
    var countOfAlarms: Int {
        alarms.count
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    func alarmTap(index: Int) {
        alarmReadToggle(index: index)
        pushToAnotherViewController(index: index)
    }
    
    private func pushToAnotherViewController(index: Int) {
        if alarms[index].type == .arrive {
            guard let coordinator = coordinator as? AlarmViewCoordinatingInAlarmViewCoordinating else { return }
            coordinator.goToLogView()
        } else {
            popToBackViewController()
        }
    }
    
    private func alarmReadToggle(index: Int) {
        alarmUseCase.readAlarm(id: alarms[index].id)
    }

    func makeAlarmRowWithInfo(index: Int) -> AlarmEntity {
        alarms[index]
    }
    
    func fetchAlamrs() {
        
        alarmUseCase.fetchAlarms()
            .sink { _ in
            } receiveValue: { alarms in
                self.alarms = alarms
            }
            .cancel(with: cancelBag)
    }
    
    func popToBackViewController() {
        guard let coordinator = coordinator as? goToRootViewControllerDelegate else { return }
        coordinator.popToRootViewController()
    }
    
    func allDeleteTap() {
        alarmUseCase.removeAllAlarms()
        popToBackViewController()
    }
    
}

protocol MoveToAnotherTab: AnyObject {
    func moveToLogTab()
}

extension MainCoordinator: MoveToAnotherTab {
    func moveToLogTab() {
        tabBarController.selectedIndex = 1
        
    }
}

extension HomeCoordinator: AlarmViewCoordinatingInAlarmViewCoordinating {
    
    func goToLogView() {
        navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.parentCoordinator?.moveToLogTab()
        }
    }
}

protocol goToRootViewControllerDelegate: AnyObject {
    func popToRootViewController()
}

extension HomeCoordinator: goToRootViewControllerDelegate, AlarmViewCoordinating {
    func popToRootViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushToAlarmViewController() {
        let alarmViewController = AlarmViewController(alarmViewModel: AlarmViewModel(coordinator: self))
        self.navigationController?.pushViewController(alarmViewController, animated: true)
    }
}

extension HomeViewModel {
    func pushToAlarmView() {
        guard let coordinator = coordinator as? AlarmViewCoordinating else { return }
        coordinator.pushToAlarmViewController()
    }
}

protocol AlarmViewCoordinating {
    func pushToAlarmViewController()
}
