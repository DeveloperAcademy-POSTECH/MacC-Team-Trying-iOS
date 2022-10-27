//
//  PlanetResponseModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum PlanetResponseModel {

    struct CreatePlanet: Decodable {
        let planetId: Int
        let code: String
    }

    struct GetInvitationCode: Decodable {
        let code: String
    }

    struct GetPlanetByCode: Decodable {
        let planetId: Int
        let name: String
        let image: String
    }
}
