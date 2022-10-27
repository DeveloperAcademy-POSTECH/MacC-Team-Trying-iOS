//
//  SignUpRequestModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct SignUpRequestModel: RequestBody {
    let email: String
    let password: String
    let name: String
    let deviceToken: String = "1"
}
