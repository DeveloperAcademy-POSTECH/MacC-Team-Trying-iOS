//
//  SignUpRequestModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum SignUpRequestModel {
    struct Email: RequestBody {
        var email: String
        var password: String
        var name: String
        var deviceToken: String
    }

    struct Kakao: RequestBody {
        let identifier: String
//        let email: String
        let name: String
        let deviceToken: String
    }

    struct Apple: RequestBody {
        let identifier: String
//        let email: String
        let name: String
        let deviceToken: String
    }
}
