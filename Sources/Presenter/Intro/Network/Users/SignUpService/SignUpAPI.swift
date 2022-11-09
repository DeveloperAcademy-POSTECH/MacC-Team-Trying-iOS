//
//  SignUpAPI.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum SignUpAPI {
    case signUp(SignUpRequestModel.Email)
    case kakao(SignUpRequestModel.Kakao)
    case apple(SignUpRequestModel.Apple)
}

extension SignUpAPI: TargetType {
    var method: HTTPMethod {
        .post
    }

    var path: String {
        switch self {
        case .signUp:
            return "/users"
        case .kakao:
            return "/oauth/kakao"
        case .apple:
            return "/oauth/apple"
        }
    }

    var body: RequestBody? {
        switch self {
        case .signUp(let body):
            return body
        case .apple(let body):
            return body
        case .kakao(let body):
            return body
        }
    }
}
