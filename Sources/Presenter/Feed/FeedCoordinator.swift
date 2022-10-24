//
//  FeedCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class FeedCoordinator: Coordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewController = FeedViewController()
        let viewModel = FeedViewModel.shared
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
}
