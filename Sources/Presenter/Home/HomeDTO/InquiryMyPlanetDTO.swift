//
//  InquiryMyPlanetDTO.swift
//  MatStar
//
//  Created by uiskim on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct UserInfo: Codable {
    let me: Mate
    let mate: Mate?
    
    let planet: Planet?
    
    struct Mate: Codable {
        let name: String
    }
    
    struct Planet: Codable {
        let name: String
        let dday: Int
        let image: String
    }

}
