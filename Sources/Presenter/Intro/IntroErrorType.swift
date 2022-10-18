//
//  IntroErrorType.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

enum IntroErrorType {
    case invalidEmail // 이메일 정보가 올바르지 않은 경우
    case invalidPassword //
    case wrongPassword // 잘못된 비밀번호를 입력했을 경우
    case wrongCertificationNumber // 인증번호가 올바르지 못한 경우
    case noUser // 등록되지 않은 유저인 경우
    case noError // 에러가 없는 경우

    var message: String? {
        switch self {
        case .invalidEmail:
            return "올바른 이메일 주소가 아닙니다."
        case .invalidPassword:
            return "한글 + 영어 + 숫자  포함 8자 이내"
        case .wrongPassword:
            return "비밀번호가 틀렸습니다."
        case .wrongCertificationNumber:
            return "인증번호가 틀렸습니다!"
        case .noUser:
            return "등록된 정보가 없습니다."
        case .noError:
            return nil
        }
    }

    var color: UIColor? {
        switch self {
        case .noError:
            return .green
        default:
            return .red
        }
    }
}
