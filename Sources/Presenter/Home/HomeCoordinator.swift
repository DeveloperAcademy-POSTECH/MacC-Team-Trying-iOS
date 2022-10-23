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

extension HomeCoordinator: AlarmViewCoordinating, CourseRegisterViewCoordinating, Popable {
    func pushToAlarmViewController() {
        let alarmViewController = AlarmViewController()
        self.navigationController?.pushViewController(alarmViewController, animated: true)
    }
    
    func pushToCourseRegisterViewController() {
        let viewController = AddCourseMapViewController()
        viewController.viewModel = AddCourseMapViewModel(coordinator: self)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
