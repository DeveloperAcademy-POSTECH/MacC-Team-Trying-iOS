//
//  InquiryMyPlanetDTO.swift
//  MatStar
//
//  Created by uiskim on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let me: User
    var mate: User?
    var planet: Planet?
    
    struct User: Codable {
        let name: String
    }
    
    struct Planet: Codable {
        let planetId: Int
        let name: String
        let dday: Int
        let image: String
    }
}
