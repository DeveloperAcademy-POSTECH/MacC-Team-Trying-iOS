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
    case purple
    case red
    
    var planetImage: UIImage? {
        switch self {
        case .blue:
            return UIImage(named: "planet_green")
            
        case .pink:
            return UIImage(named: "Planet1")
            
        case .orange:
            return UIImage(named: "Planet2")
            
        case .purple:
            return UIImage(named: "Planet3")
            
        case .red:
            return UIImage(named: "Planet4")
        }
    }
}

struct Planet {
    let planetId: Int
    let name: String
    let planetTyle: PlanetType
    let createdDate: String
    let courses: [Course]
    
    init(planetId: Int, name: String, planetTyle: PlanetType, createdDate: String) {
        self.planetId = planetId
        self.name = name
        self.planetTyle = planetTyle
        self.createdDate = createdDate
        self.courses = []
    }
}

//extension Planet {
//    static let testUserPlanet: Planet = {
//        .init(name: "맛스타행성", planetTyle: .blue, createdDate: "2022년 10월 15일", courses: [Course.firstDateCoures, Course.secondDateCourse])
//    }()
//    
//    static let testUserSatellites: [Planet] = [
//        Planet(name: "루미행성", planetTyle: .pink, createdDate: "2022년 09월 01일", courses: []),
//        Planet(name: "유스행성", planetTyle: .orange, createdDate: "2022년 08월 01일", courses: [])
//    ]
//}
