//
//  TextFieldErrorable.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol TextFieldWithMessageViewComponent: Component {
    var delegate: TextFieldWithMessageViewComponentDelegate? { get set }
    /// 에러메시지를 보여주는 함수
    /// - Parameter direction:성공, 실패 
    func updateState(_ errorType: TextFieldState)
    /// 텍스트필드의 키보드를 올립니다
    func textFieldBecomeFirstResponder()
    /// 텍스트필드의 키보드를 내립니다.
    func textFieldResignFirstResponder()
    /// 텍스트를 수정합니다.
    func updateText(_ text: String)
}
