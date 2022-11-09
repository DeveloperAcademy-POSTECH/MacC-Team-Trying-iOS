//
//  SignInAPI.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum SignInAPI {
    case signIn(SignInRequestModel.Email)
    case kakao(SignInRequestModel.Kakao)
    case apple(SignInRequestModel.Apple)
}

extension SignInAPI: TargetType {
    var method: HTTPMethod { .post }

    var path: String {
        switch self {
        case .signIn:
            return "/users/login"
        case .kakao:
            return "/oauth/kakao/login"
        case .apple:
            return "/oauth/apple/login"
        }
    }

    var body: RequestBody? {
        switch self {
        case .signIn(let body):
            return body
        case .kakao(let body):
            return body
        case .apple(let body):
            return body
        }
    }
}
