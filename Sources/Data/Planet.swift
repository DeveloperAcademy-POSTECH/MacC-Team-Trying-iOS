//
//  Planet.swift
//  MatStar
//
//  Created by uiskim on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

enum PlanetType {
    case blue
    case pink
    case orange
    
    var planetImage: UIImage? {
        switch self {
        case .blue:
            return UIImage(named: "MyPlanetImage")
            
        case .pink:
            return UIImage(named: "LumiPlanet")
            
        case .orange:
            return UIImage(named: "YouthPlanet")
        }
    }
}

struct Planet {
    let planetName: String
    let planetTyle: PlanetType
    let createdDate: String
    let courses: [Course]
}

extension Planet {
    static let testUserPlanet: Planet = {
        .init(planetName: "맛스타행성", planetTyle: .blue, createdDate: "2022년10월15일", courses: [Course.firstDateCoures, Course.secondDateCourse])
    }()
    
    static let testUserSatellites: [Planet] = [
        Planet(planetName: "루미행성", planetTyle: .pink, createdDate: "2022년9월1일", courses: []),
        Planet(planetName: "유스행성", planetTyle: .orange, createdDate: "2022년8월1일", courses: [])
    ]
}
