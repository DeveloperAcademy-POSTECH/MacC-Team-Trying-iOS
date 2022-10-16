//
//  LoginViewModelTests.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import XCTest
@testable import MatStar

final class LoginViewModelTests: XCTestCase {
    var sut: LoginBusinessLogic!
    var mockIntroCoordinator: MockIntroCoordinator!

    override func setUp() {
        super.setUp()
        mockIntroCoordinator = MockIntroCoordinator()
        sut = LoginViewModel(coordinator: mockIntroCoordinator)
    }

    override func tearDown() {
        sut = nil
        mockIntroCoordinator = nil
        super.tearDown()
    }

    func testLoginViewModel_이메일로_로그인하기_버튼이_한번_눌리면_코디네이터_화면이_전환됩니다() {
        // when
        sut.loginButtonDidTapped()

        // then
        XCTAssertEqual(mockIntroCoordinator.coordinateToEnterEmailSceneCount, 1)
    }
}
