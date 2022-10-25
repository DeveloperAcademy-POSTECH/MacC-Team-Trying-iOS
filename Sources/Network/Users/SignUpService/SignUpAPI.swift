//
//  SignUpAPI.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum SignUpAPI {
    case signUp(SignUpRequestModel)
}

extension SignUpAPI: TargetType {
    var method: HTTPMethod {
        switch self {
        case .signUp:
            return .post
        }
    }

    var path: String {
        switch self {
        case .signUp:
            return "/users"
        }
    }

    var body: RequestBody? {
        switch self {
        case .signUp(let body):
            return body
        }
    }
}
