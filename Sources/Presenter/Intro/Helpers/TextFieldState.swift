//
//  TextFieldState.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

enum TextFieldState {
    case invalidEmail // 이메일 정보가 올바르지 않은 경우
    case invalidPassword
    case invalidNickname
    case validPassword
    case validNickname
    case wrongPassword // 잘못된 비밀번호를 입력했을 경우
    case wrongCertificationNumber // 인증번호가 올바르지 못한 경우
    case noUser // 등록되지 않은 유저인 경우
    case good // 에러가 없는 경우
    case empty
    case emptyPassword
    case emptyNickname
    case duplicatedSignUp
    case isNotSignUp

    var message: String? {
        switch self {
        case .invalidEmail:
            return "올바른 이메일 주소가 아닙니다."
        case .invalidPassword:
            return "한글 + 영어 + 숫자 포함 8~12자 이내"
        case .invalidNickname:
            return "한글 + 영어 + 숫자 포함 8자 이내"
        case .validPassword:
            return "한글 + 영어 + 숫자 포함 8~12자 이내"
        case .validNickname:
            return "한글 + 영어 + 숫자 포함 8자 이내"
        case .emptyPassword:
            return "한글 + 영어 + 숫자 포함 8~12자 이내"
        case .emptyNickname:
            return "한글 + 영어 + 숫자 포함 8자 이내"
        case .wrongPassword:
            return "비밀번호가 틀렸습니다."
        case .wrongCertificationNumber:
            return "인증번호가 틀렸습니다!"
        case .noUser:
            return "등록된 정보가 없습니다."
        case .good:
            return nil
        case .empty:
            return ""
        case .duplicatedSignUp:
            return "이미 가입된 이메일 주소입니다!"
        case .isNotSignUp:
            return "처음 보는 이메일 주소예요!"
        }
    }

    var borderColor: UIColor? {
        switch self {
        case .good:
            return .clear
        case .empty:
            return .clear
        case .emptyNickname:
            return .clear
        case .emptyPassword:
            return .clear
        case .validPassword:
            return .green
        case .validNickname:
            return .green
        default:
            return .red
        }
    }

    var textColor: UIColor? {
        switch self {
        case .good:
            return .clear
        case .empty:
            return .clear
        case .emptyNickname:
            return .designSystem(.grayC5C5C5)
        case .emptyPassword:
            return .designSystem(.grayC5C5C5)
        case .validPassword:
            return .green
        case .validNickname:
            return .green
        default:
            return .red
        }
    }

}
