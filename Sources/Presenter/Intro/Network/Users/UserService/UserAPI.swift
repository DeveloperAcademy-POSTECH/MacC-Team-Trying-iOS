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
    case deregister
    case logout
}

extension UserAPI: TargetType {
    var method: HTTPMethod {
        switch self {
        case .users:
            return .get
        case .deregister:
            return .delete
        case .logout:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .users:
            return "/users"
        case .deregister:
            return "/users"
        case .logout:
            return "/users/logout"
        }

    }
}
