//
//  AlarmViewModel.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct Alarm {
    
    init(
        type: AlarmType,
        courseName: String,
        dateString: String,
        personName: String? = nil,
        alreadyRead: Bool
    ) {
        self.type = type
        self.courseName = courseName
        self.dateString = dateString
        self.alreadyRead = alreadyRead
        self.personName = personName
    }
    
    let type: AlarmType
    var alreadyRead: Bool
    private let dateString: String
    private let courseName: String
    private let personName: String?
    
    var iconImageString: String {
        switch type {
        case .new:
            return "alarmCal"
        case .tommorow:
            return "alarmHeart"
        case .arrive:
            return "alarmStar"
        case .mate:
            return "alarmMate"
        }
    }
    
    var title: String {
        switch type {
        case .new:
            return "새로운 계획"
        case .tommorow:
            return "데이트 D-1"
        case .arrive:
            return "후기 도착"
        case .mate:
            return "메이트 행성 도착"
        }
    }

    var description: String {
        switch type {
        case .new:
            guard let personName = personName else { return "" }
            return "\(personName)님이 \(dateString)에 [\(courseName)]\n새로운 데이트 코스를 등록했습니다."
        case .tommorow:
            return "두근두근!! [\(courseName)]\n데이트가 내일로 다가왔어요~"
        case .arrive:
            return "[\(courseName)] 별자리가 만들어졌어요~\n서둘러서 후기를 등록해보세요!"
        case .mate:
            return "축하드립니다!\n지금부터 메이트와 함께 사용해보세요~"
        }
    }
    
    var timeLeft: String {
        getTimesLeft(date: dateString)
    }

    private func getTimesLeft(date: String) -> String {
        //TODO: 받아온 API에서 현재 날짜 계산
        return "12시간 전"
    }
}

enum AlarmType {
    case new
    case tommorow
    case arrive
    case mate
}

protocol AlarmViewCoordinatingInAlarmViewCoordinating {
    func goToLogView()
}

class AlarmViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    @Published var alarms: [Alarm] = [
        .init(type: .arrive, courseName: "포항풀코스", dateString: "11월 22일", alreadyRead: true),
        .init(type: .tommorow, courseName: "포항풀코스", dateString: "11월 22일", alreadyRead: true),
        .init(type: .new, courseName: "포항풀코스", dateString: "11월 22일", personName: "카리나", alreadyRead: false), .init(type: .mate, courseName: "", dateString: "11월 22일", alreadyRead: false)
    ]
    
    var countOfAlarms: Int {
        alarms.count
    }
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
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
        alarms[index].alreadyRead = true
        //TODO: 알람 Read Post/Put
    }

    func makeAlarmRowWithInfo(index: Int) -> Alarm {
        alarms[index]
    }
    
    func fetchAlamrs() {
        
        alarms = alarms
    }
    
    func popToBackViewController() {
        guard let coordinator = coordinator as? goToRootViewControllerDelegate else { return }
        coordinator.popToRootViewController()
    }
    
    func allDeleteTap() {
        alarms = []
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

protocol goToRootViewControllerDelegate {
    func popToRootViewController()
}

extension HomeCoordinator: goToRootViewControllerDelegate, AlarmViewCoordinating {
    func popToRootViewController() {
        navigationController?.popViewController(animated: true)
    }
    
    func pushToAlarmViewController() {
        let alarmViewController = AlarmViewConroller(alarmViewModel: AlarmViewModel(coordinator: self))
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
