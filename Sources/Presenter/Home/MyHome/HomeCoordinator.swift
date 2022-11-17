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
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = HomeViewModel(coordinator: self)
        let viewController = HomeViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func startAddCourseFlow(type: AddCourseFlowType) {
        let addCourseCoordinator = AddCourseCoordinator(type: type,navigationController: navigationController)
        addCourseCoordinator.start()
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
