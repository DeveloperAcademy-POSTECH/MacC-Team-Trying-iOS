//
//  UserAPI.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum UserAPI {
    case users
}

extension UserAPI: TargetType {
    var method: HTTPMethod { .get }
    var path: String { "/users" }
}
