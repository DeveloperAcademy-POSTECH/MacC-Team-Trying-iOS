//
//  PlanetRequestModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum PlanetRequestModel {

    struct CreatePlanet: RequestBody {
        let name: String
        let image: String
    }

    struct JoinPlanet: RequestBody {
        let code: String
    }

    struct GetInvitationCode: RequestBody {
        let planetID: Int
    }

    struct GetPlanetByCode: RequestBody {
        let code: String
    }
}
