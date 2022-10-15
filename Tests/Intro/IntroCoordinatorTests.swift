//
//  IntroCoordinatorTests.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import XCTest
@testable import MatStar

final class IntroCoordinatorTests: XCTestCase {
    var sut: IntroCoordinatorProtocol!
    var mockNavigationController: MockNavigationController!

    override func setUp() {
        super.setUp()
        mockNavigationController = MockNavigationController(rootViewController: .init())
        sut = IntroCoordinator(navigationController: mockNavigationController)
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testIntroCoordinator_이메일입력_화면으로_전환합니다() {
        // when
        sut.coordinateToEnterEmailScene()

        // then
        XCTAssertEqual(mockNavigationController.pushViewControllerCalled, true)
        XCTAssertTrue(mockNavigationController.pushedViewController is EnterEmailViewController)
    }

}
