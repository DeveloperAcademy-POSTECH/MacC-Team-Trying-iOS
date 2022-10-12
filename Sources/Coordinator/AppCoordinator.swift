//
//  AppCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

class AppCoordinator: Coordinator {
    let window: UIWindow
    weak var presenter: UINavigationController?

    init(window: UIWindow) {
        self.window = window
        
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: true)
        self.presenter = navigationController
    }
    
    func start() {
        window.rootViewController = presenter
        
        // TODO: 로그인 분기처리
        let coordinator = MainCoordinator(presenter: presenter)
        coordinator.start()
        
        window.makeKeyAndVisible()
    }
}
