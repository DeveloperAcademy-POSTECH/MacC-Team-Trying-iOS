//
//  Planet.swift
//  MatStar
//
//  Created by uiskim on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum PlanetType {
    case blue
    case pink
    case orange
}

struct Planet {
    let planetName: String
    let planetTyle: PlanetType
    let createdDate: String
    let courses: [Course]
}
