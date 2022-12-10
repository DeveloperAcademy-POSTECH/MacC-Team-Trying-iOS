//
//  LogMapCoordinator.swift
//  우주라이크
//
//  Created by 김승창 on 2022/12/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

final class LogMapCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(courses: [CourseEntity]) {
        let viewModel = LogMapViewModel(coordinator: self, courses: courses)
        let viewController = LogMapViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension LogMapCoordinator: Popable {
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
