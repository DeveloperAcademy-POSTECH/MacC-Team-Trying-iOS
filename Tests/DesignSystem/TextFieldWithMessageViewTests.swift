//
//  TextFieldWithMessageViewTests.swift
//  MatStarTests
//
//  Created by Jaeyong Lee on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import XCTest
@testable import MatStar

final class TextFieldWithMessageViewTests: XCTestCase {

    var sut: TextFieldWithMessageView!

    override func setUp() {
        super.setUp()
        sut = TextFieldWithMessageView()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func testTextFieldWithMessageView_이메일_텍스트필드를_생성합니다() {
        let textType = TextFieldWithMessageView.TextType.email
        sut = TextFieldWithMessageView(textType: textType)
        XCTAssertEqual(sut.textField.placeholder, textType.placeholder)
    }

    func testTextFieldWithMessageView_닉네임_텍스트필드를_생성합니다() {
        let textType = TextFieldWithMessageView.TextType.nickname
        sut = TextFieldWithMessageView(textType: textType)
        XCTAssertEqual(sut.textField.placeholder, textType.placeholder)
    }

    func testTextFieldWithMessageView_인증번호_텍스트필드를_생성합니다() {
        let textType = TextFieldWithMessageView.TextType.certificationNumber
        sut = TextFieldWithMessageView(textType: textType)
        XCTAssertEqual(sut.textField.placeholder, textType.placeholder)
    }

    func testTextFieldWithMessageView_비밀번호_텍스트필드를_생성합니다() {
        let textType = TextFieldWithMessageView.TextType.password
        sut = TextFieldWithMessageView(textType: textType)
        XCTAssertEqual(sut.textField.placeholder, textType.placeholder)
    }

    func testTextFieldWithMessageView_이메일_validation_오류메시지가_발생했습니다() {
        let error = TextFieldState.invalidEmail
        sut.updateState(error)
        XCTAssertEqual(sut.stateLabel.text, error.message)
        XCTAssertEqual(sut.stateLabel.textColor, error.borderColor)
        XCTAssertEqual(sut.textField.layer.borderColor, error.borderColor?.cgColor)
    }

    func testTextFieldWithMessageView_텍스트_clear버튼을_누르면_텍스트가_모두_사라집니다() {
        // given
        sut.textField.text = "유저가 쓴 텍스트"
        // when
        sut.clearButtonDidTap()
        // then
        XCTAssertEqual(sut.textField.text, "")
    }
}
