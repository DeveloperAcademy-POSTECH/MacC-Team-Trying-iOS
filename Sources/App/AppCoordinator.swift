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

    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.navigationController = navigationController
    }
    
    func start() {
        window.rootViewController = navigationController

        if UserDefaults.standard.string(forKey: "accessToken") != nil {
            let coordinator = MainCoordinator(navigationController: navigationController)
            coordinator.start()
            window.makeKeyAndVisible()
            return
        }

//        let coordinator = IntroCoordinator(navigationController: navigationController)
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
//        coordinator.delegate = self
        window.makeKeyAndVisible()
        return
    }

    func coordinateToMainScene() {
        let coordinator = MainCoordinator(navigationController: navigationController)
        coordinator.start()
    }
}
