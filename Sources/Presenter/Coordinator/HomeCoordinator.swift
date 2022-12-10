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
}

protocol AlarmViewCoordinatingInAlarmViewCoordinating {
    func goToLogView()
}

extension HomeCoordinator: AlarmViewCoordinatingInAlarmViewCoordinating {
    func goToLogView() {
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            self.parentCoordinator?.moveToLogTab()
        }
    }
    
    func startLogMapFlow(courses: [CourseEntity]) {
        let coordinator = LogMapCoordinator(navigationController: navigationController)
        coordinator.start(courses: courses)
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
        DispatchQueue.main.async {
            self.navigationController?.popViewController(animated: true)
        }

    }
    
    func pushToAlarmViewController() {
        guard !(navigationController?.topViewController is AlarmViewController) else { return }
        let alarmViewController = AlarmViewController(alarmViewModel: AlarmViewModel(coordinator: self))
        alarmViewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(alarmViewController, animated: true)
    }
}

// MARK: - Course Flow
extension HomeCoordinator {
    func startAddCourseFlow(courseRequestDTO: CourseRequestDTO) {
        let addCourseCoordinator = AddCourseCoordinator(navigationController: navigationController)
        addCourseCoordinator.start(courseRequestDTO)
    }
    
    func startRegisterReviewFlow(courseRequestDTO: CourseRequestDTO) {
        let registerReviewCoordinator = RegisterReviewCoordinator(navigationController: navigationController, type: .add)
        registerReviewCoordinator.start(courseRequestDTO)
    }
    
    func startEditCourseFlow(courseRequestDTO: CourseRequestDTO) {
        let editCourseCoordinator = EditCourseCoordinator(navigationController: navigationController)
        editCourseCoordinator.start(courseRequestDTO)
    }
    
    func startAddPlanFlow(courseRequestDTO: CourseRequestDTO) {
        let addPlanCoordinator = AddPlanCoordinator(navigationController: navigationController)
        addPlanCoordinator.start(courseRequestDTO)
    }
    
    func startEditPlanFlow(courseRequestDTO: CourseRequestDTO) {
        let editPlanCoordinator = EditPlanCoordinator(navigationController: navigationController)
        editPlanCoordinator.start(courseRequestDTO)
    }
}
