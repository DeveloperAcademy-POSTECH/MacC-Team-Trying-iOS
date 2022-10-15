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
    func showError(type errorType: IntroErrorType)
}
