//
//  IntroButtonTests.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import XCTest
@testable import MatStar

final class IntroButtonTests: XCTestCase {

    var sut: IntroButton!

    override func setUp() {
        super.setUp()
        sut = IntroButton()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testIntroButton_제목을변경합니다() {
        let changedTitle = "변경된 제목"
        sut.title = changedTitle

        XCTAssertEqual(sut.title, changedTitle)
    }
}
