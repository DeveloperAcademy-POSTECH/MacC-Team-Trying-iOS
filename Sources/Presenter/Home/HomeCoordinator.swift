//
//  HomeCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    weak var parentCoordinator: MoveToAnotherTab?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
        print("tabbar", self.navigationController?.tabBarController)
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
}

extension HomeCoordinator: AlarmViewCoordinating, CourseDetailCoordinating {
    func pushToCourseDetailViewController() {
        let courseDetailViewController = CoursesViewController()
        self.navigationController?.pushViewController(courseDetailViewController, animated: true)
    }
    
    func pushToAlarmViewController() {
        let alarmViewController = AlarmNViewConroller(alarmViewModel: AlarmViewModel(coordinator: self))
        self.navigationController?.pushViewController(alarmViewController, animated: true)
    }
    
    func startAddCourseFlow() {
        let addCourseCoordinator = AddCourseCoordinator(navigationController: navigationController)
        addCourseCoordinator.start()
    }
}

// kyu
extension HomeCoordinator: AlarmViewCoordinatingInAlarmViewCoordinating {
    
    func goToLogView() {
        navigationController?.popViewController(animated: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            self.parentCoordinator?.moveToLogTab()
        }
    }
}

protocol goToRootViewControllerDelegate {
    func popToRootViewController()
}

extension HomeCoordinator: goToRootViewControllerDelegate {
    func popToRootViewController() {
        navigationController?.popViewController(animated: true)
    }
}
