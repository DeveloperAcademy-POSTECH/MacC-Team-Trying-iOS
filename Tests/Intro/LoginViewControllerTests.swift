//
//  LoginViewControllerTests.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import XCTest
@testable import MatStar

final class LoginViewControllerTests: XCTestCase {

    var sut: LoginViewController!
    var mockLoginViewModel: MockLoginViewModel!
    var mockIntroCoordinator: MockIntroCoordinator!

    override func setUp() {
        super.setUp()
        mockIntroCoordinator = MockIntroCoordinator()
        mockLoginViewModel = MockLoginViewModel(coordinator: mockIntroCoordinator)
        sut = LoginViewController(viewModel: mockLoginViewModel)
    }

    override func tearDown() {
        sut = nil
        mockLoginViewModel = nil
        mockIntroCoordinator = nil
        super.tearDown()
    }
}
