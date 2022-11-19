//
//  HomeCoordinator.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    weak var parentCoordinator: MoveToAnotherTab?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startAddCourseFlow(courseRequestDTO: CourseRequestDTO) {
        let addCourseCoordinator = AddCourseCoordinator(navigationController: navigationController)
        addCourseCoordinator.start(courseRequestDTO)
    }
}

//extension HomeCoordinator: AlarmViewCoordinating, CourseDetailCoordinating {
//    func pushToCourseDetailViewController() {
//        let courseDetailViewController = CoursesViewController()
//        self.navigationController?.pushViewController(courseDetailViewController, animated: true)
//    }
//
//    func pushToAlarmViewController() {
//        let alarmViewController = AlarmViewController()
//        self.navigationController?.pushViewController(alarmViewController, animated: true)
//    }
//
//    func startAddCourseFlow() {
//        let addCourseCoordinator = AddCourseCoordinator(navigationController: navigationController)
//        addCourseCoordinator.start()
//    }
//}

protocol AlarmViewCoordinatingInAlarmViewCoordinating {
    func goToLogView()
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

protocol AlarmViewCoordinating {
    func pushToAlarmViewController()
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
