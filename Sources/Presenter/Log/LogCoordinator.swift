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
    
    init(navigationController: UINavigationController) { self.navigationController = navigationController }
    
    // MARK: Coordinating functions
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = LogHomeViewModel(coordinator: self)
        let viewController = LogHomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    
    func presentTicketViewController() {
        let viewModel = LogTicketViewModel(coordinator: self)
        let viewController = LogTicketViewController(viewModel: viewModel)
        viewController.view.backgroundColor = .clear
        viewController.modalPresentationStyle = .popover
        navigationController?.present(viewController, animated: true)
    }
    
    func pushMyConstellationViewController() {
        // TODO: 수정이요~
        let viewModel = LogHomeViewModel(coordinator: self)
        let vc = MyConstellationViewModel(coordinator: self)
        let viewController = MyConstellationViewController(viewModel: vc)
        viewController.courses = viewModel.courses
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
