//
//  EmailVerificationAPI.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum EmailVerificationAPI {
    case sendEmail(EmailVerificationRequestModel.SendModel)
    case verificationCode(EmailVerificationRequestModel.VerificationModel)
    case resetPassword(EmailVerificationRequestModel.ResetPasswordModel)
}

extension EmailVerificationAPI: TargetType {

    var method: HTTPMethod {
        switch self {
        case .sendEmail:
            return .post
        case .verificationCode:
            return .patch
        case .resetPassword:
            return .patch
        }
    }

    var path: String {
        switch self {
        case .sendEmail:
            return "/certification"
        case .verificationCode:
            return "/certification"
        case .resetPassword:
            return "/users/password"
        }
    }

    var body: RequestBody? {
        switch self {
        case .sendEmail(let body):
            return body
        case .verificationCode(let body):
            return body
        case .resetPassword(let body):
            return body
        }
    }
}
