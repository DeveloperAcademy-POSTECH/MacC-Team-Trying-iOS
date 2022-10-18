//
//  String+.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit


extension String {
    /// 특정글자의 font와 textColor를 바꿀수 있는 메서드
    /// - Parameters:
    ///   - name: 바뀌지 않는 문자열
    ///   - appendString: 바꾸고싶은 문자열
    ///   - changeAppendStringSize: 바꾸고싶은 문자열의 fontSize
    ///   - changeAppendStringWieght: 바꾸고싶은 문자열의 fontWeight
    ///   - changeAppendStringColor: 바꾸고 싶은 문자열의 fontColor
    /// - Returns: UILabel속성이라면 .text가 아니라 .attributedText로 받아야함
    static func makeAtrributedString(name: String,
                                     appendString: String,
                                     changeAppendStringSize: CGFloat,
                                     changeAppendStringWieght: UIFont.Weight,
                                     changeAppendStringColor: UIColor) -> NSMutableAttributedString {
        let profileString = name + appendString
        let attributedQuote = NSMutableAttributedString(string: profileString)
        attributedQuote.addAttribute(.foregroundColor, value: changeAppendStringColor, range: (profileString as NSString).range(of: appendString))
        attributedQuote.addAttribute(.font, value: UIFont.systemFont(ofSize: changeAppendStringSize, weight: .regular), range: (profileString as NSString).range(of: appendString))
        return attributedQuote
    }
}
