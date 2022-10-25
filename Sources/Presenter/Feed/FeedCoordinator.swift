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

        let viewModel = FeedViewModel(coordinator: self)
        let viewController = FeedViewController()
        viewController.viewModel = viewModel
        
        navigationController.pushViewController(viewController, animated: true)
        navigationController.isNavigationBarHidden = true
    }
}

extension FeedCoordinator: FeedMapCoordinating {
    func pushToAlarmViewController() {
        let feedMapConroller = FeedMapViewController()
        navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(feedMapConroller, animated: true)
    }
}
