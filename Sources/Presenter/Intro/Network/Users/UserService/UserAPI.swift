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
    case editNickname(UserRequestModel.EditNickname)
    case editPlanet(UserRequestModel.EditPlanet)
    case editPassword(UserRequestModel.EditPassword)
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
        case .editNickname:
            return .put
        case .editPassword:
            return .put
        case .editPlanet:
            return .put
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
        case .editNickname:
            return "/users/name"
        case .editPassword:
            return "/users/password"
        case .editPlanet:
            return "/planets"
        }
    }

    var body: RequestBody? {
        switch self {
        case .users:
            return nil
        case .deregister:
            return nil
        case .logout:
            return nil
        case .editNickname(let body):
            return body
        case .editPassword(let body):
            return body
        case .editPlanet(let body):
            return body
        }
    }
}
