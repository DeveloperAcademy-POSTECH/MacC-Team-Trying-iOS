//
//  LoginViewModel+Mock.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

@testable import MatStar
final class MockLoginViewModel: LoginBusinessLogic {
    var coordinator: LoginCoordinatorLogic

    init(coordinator: LoginCoordinatorLogic) {
        self.coordinator = coordinator
    }
    var loginButtonDidTappedCount: Int = 0
    func loginButtonDidTapped() {
        loginButtonDidTappedCount += 1
    }
}
