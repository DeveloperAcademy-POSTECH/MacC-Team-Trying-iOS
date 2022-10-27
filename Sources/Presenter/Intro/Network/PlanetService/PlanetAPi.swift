//
//  PlanetAPi.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum PlanetAPI {
    case create(PlanetRequestModel.CreatePlanet)
    case join(PlanetRequestModel.JoinPlanet)
    case getInvitationCode(PlanetRequestModel.GetInvitationCode)
    case getPlanetByCode(PlanetRequestModel.GetPlanetByCode)
}

extension PlanetAPI: TargetType {

    var method: HTTPMethod {
        switch self {
        case .create:
            return .post
        case .join:
            return .post
        case .getInvitationCode:
            return .get
        case .getPlanetByCode:
            return .get
        }
    }

    var path: String {
        switch self {
        case .create:
            return "/planets"
        case .join:
            return "/planets/join"
        case .getInvitationCode(let query):
            return "/planets/\(query.planetID)/code"
        case .getPlanetByCode:
            return "/planets/join"
        }
    }

    var body: RequestBody? {
        switch self {
        case .create(let body):
            return body
        case .join(let body):
            return body
        case .getInvitationCode:
            return nil
        case .getPlanetByCode:
            return nil
        }
    }

    var query: QueryItems? {
        switch self {
        case .create:
            return nil
        case .join:
            return nil
        case .getInvitationCode:
            return nil
        case .getPlanetByCode(let query):
            return ["code": query.code]
        }
    }
}
