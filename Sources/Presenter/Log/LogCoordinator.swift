//
//  LogCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class LogCoordinator: Coordinator,
                            MyConstellationViewCoordinating,
                            TicketViewCoodinating,
                            LogMapViewCoordinating,
                            Popable {
    
    weak var navigationController: UINavigationController?
    
    weak var parentCoordinator: MoveToHomeTap?
    
    init(navigationController: UINavigationController) { self.navigationController = navigationController }
    
    // MARK: Coordinating functions
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = LogHomeViewModel(coordinator: self)
        let viewController = LogHomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    // TicketView로 전환
    func presentTicketViewController(courses: [CourseEntity], currentIndex: Int) {
        let viewModel = LogTicketViewModel(coordinator: self, courses: courses, currentIndex: currentIndex)
        let viewController = LogTicketViewController(viewModel: viewModel)
        navigationController?.present(viewController, animated: true)
    }
    
    func pushMyConstellationViewController(courses: [CourseEntity]) {
        let viewModel = MyConstellationViewModel(coordinator: self, courses: courses)
        let viewController = MyConstellationViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func pushLogMapViewController() {
        let viewModel = LogMapViewModel(coordinator: self)
        let viewController = LogMapViewController(viewModel: viewModel)
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol MoveFromLogToHome {
    func goToHomeView(course: CourseEntity)
}

extension LogCoordinator: MoveFromLogToHome {
    func goToHomeView(course: CourseEntity) {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true)
            self.parentCoordinator?.moveToHomeTap(course: course)
        }
    }
}
