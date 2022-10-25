//
//  EmailVerificationRequestModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum EmailVerificationRequestModel {
    struct SendModel: Encodable {
        let email: String
    }
}
