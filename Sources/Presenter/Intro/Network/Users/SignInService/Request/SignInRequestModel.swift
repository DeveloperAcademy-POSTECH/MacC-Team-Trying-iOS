//
//  SignInRequestModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum SignInRequestModel {
    struct Email: RequestBody {
        let email: String
        let password: String
        let deviceToken: String
    }

    struct Kakao: RequestBody {
        let identifier: String
        let deviceToken: String
    }

    struct Apple: RequestBody {
        let identifier: String
        let deviceToken: String
    }
}
