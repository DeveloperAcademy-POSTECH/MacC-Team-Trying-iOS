//
//  EmailVerificationRequestModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum EmailVerificationRequestModel {
    struct SendModel: RequestBody {
        let email: String
    }

    struct VerificationModel: RequestBody {
        let email: String
        let code: String
    }

    struct ResetPasswordModel: RequestBody {
        let email: String
    }
}
