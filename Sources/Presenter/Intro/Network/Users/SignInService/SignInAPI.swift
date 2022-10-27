//
//  SignInAPI.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum SignInAPI {
    case signIn(SignInRequestModel)
}

extension SignInAPI: TargetType {
    var method: HTTPMethod {
        switch self {
        case .signIn:
            return .post
        }
    }

    var path: String {
        switch self {
        case .signIn:
            return "/users/login"
        }
    }

    var body: RequestBody? {
        switch self {
        case .signIn(let body):
            return body
        }
    }
}
