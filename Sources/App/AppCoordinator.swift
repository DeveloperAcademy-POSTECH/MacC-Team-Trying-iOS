//
//  AppCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class AppCoordinator: Coordinator, IntroCoordinatorDelegate {
    let window: UIWindow
    weak var navigationController: UINavigationController?

    var mainCoordinator: Coordinator?
    
    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.navigationController = navigationController
    }
    
    func start() {
        window.rootViewController = navigationController

        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.delegate = self
        coordinator.start()
        window.makeKeyAndVisible()
        return

        if UserDefaults.standard.string(forKey: "accessToken") != nil {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.start()
            window.makeKeyAndVisible()
            return
        }
    }

    func coordinateToMainScene() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
