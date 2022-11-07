//
//  PlanetDTO.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct PlanetsResponse: Decodable {
    let planets: [PlanetDTO]
    let size: Int
    let hasNext: Bool
}

struct PlanetDTO: Codable {
    let planetID: Int
    let name, image: String
    let dday: Int?
    let followed: Bool?

    enum CodingKeys: String, CodingKey {
        case planetID = "planetId"
        case name, image, dday, followed
    }
}
