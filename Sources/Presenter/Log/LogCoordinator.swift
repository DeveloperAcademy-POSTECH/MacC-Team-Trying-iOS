//
//  LogCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class LogCoordinator: Coordinator, MyConstellationViewCoordinating, TicketViewCoodinating, Popable {
    
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) { self.navigationController = navigationController }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = LogHomeViewModel(coordinator: self)
        let viewController = LogHomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentTicketViewController() {
        
    }
    
    func pushMyConstellationViewController() {
        let viewModel = LogHomeViewModel(coordinator: self)
        let viewController = MyConstellationViewController()
        viewController.courses = viewModel.courses
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
