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
        Task {
            if try await alarmReadToggle(index: index) {
                self.alarms[index].checked = true
                self.notificateAndMoveUi(index: index)
            }
        }
    }
    
    private func notificateAndMoveUi(index: Int) {
        let alarm = alarms[index]
        if alarm.type == .arrive {
            guard let coordinator = coordinator as? AlarmViewCoordinatingInAlarmViewCoordinating else { return }
            coordinator.goToLogView()
            NotificationCenter.default.post(name: Notification.Name("REVIEW"), object: "\(alarm.targetId)")
        } else {
            // MARK: 🛑 추후 홈뷰로 이동할때 🛑
            NotificationCenter.default.post(name: Notification.Name("COURSE"), object: "\(alarm.targetId)")
            popToBackViewController()
        }
    }
    
    private func alarmReadToggle(index: Int) async throws -> Bool {
        return try await alarmUseCase.readAlarm(id: alarms[index].id)
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
        Task {
            if try await alarmUseCase.removeAllAlarms() {
                self.alarms = []
            }
        }
    }
    
    func deleteAlarmAt(_ index: Int) {
        Task {
            let id = alarms[index].id
            if try await alarmUseCase.deleteAlarm(id: id ) {
                self.alarms = self.alarms.filter { $0.id != id }
            }
        }
    }
}
