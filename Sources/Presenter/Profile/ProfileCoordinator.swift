//
//  ProfileCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class ProfileCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = ProfileViewModel(coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Coordinating Methods
extension ProfileCoordinator: EditDayViewCoordinating, Popable {
    func pushToEditDayView() {
        let viewModel = EditDayViewModel(coordinator: self)
        let viewController = EditDayViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }
}
