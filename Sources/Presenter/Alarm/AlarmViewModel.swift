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
//    let alarmCourseReviewUseCase: AlarmCourseReviewUseCaseDelegate = AlarmCourseReviewUseCase(alarmCourseReviewInterface: AlarmCourseReviewRepository())
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
        let alarm = alarms[index]
        if alarm.type == .arrive {
            NotificationCenter.default.post(name: Notification.Name("REVIEW"), object: "\(alarm.targetId)")
            guard let coordinator = coordinator as? AlarmViewCoordinatingInAlarmViewCoordinating else { return }
            coordinator.goToLogView()
        } else {
            NotificationCenter.default.post(name: Notification.Name("COURSE"), object: "\(alarm.targetId)")
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
