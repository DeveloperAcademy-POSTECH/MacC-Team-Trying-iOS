//
//  SplashViewModel.swift
//  우주라이크
//
//  Created by 김승창 on 2022/11/30.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class SplashViewModel {
    var coordinator: AppCoordinator
    
    init(coordinator: AppCoordinator) {
        self.coordinator = coordinator
    }
    
    func startAppCoordinator() {
        self.coordinator.start()
    }
}
