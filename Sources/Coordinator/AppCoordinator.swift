//
//  AppCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    var delegate: CoordinatorFinishDelegate?
    let window: UIWindow
    var presenter: UINavigationController
    var childCoordinators: [Coordinator]

    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: true)
        self.presenter = navigationController
        
        self.childCoordinators = []
    }
    
    func start() {
        window.rootViewController = presenter
        
        // TODO: 로그인 분기처리
        let coordinator = MainCoordinator(presenter: presenter)
        coordinator.delegate = self
        childCoordinators.append(coordinator)
        coordinator.start()
        
        window.makeKeyAndVisible()
    }
}
