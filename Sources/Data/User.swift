//
//  User.swift
//  MatStar
//
//  Created by uiskim on 2022/10/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct User {
    let email: String
    let password: String
    let nickName: String
    var myPlanet: Planet?
    let satellites: [Planet]
    
    init(nickName: String, myPlanet: Planet? = nil) {
        self.email = ""
        self.password = ""
        self.nickName = nickName
        self.satellites = []
    }
}

//extension User {
//    static let testUser: User = {
//        .init(email: "matStar1015@gmail.com", password: "matStar1015", nickName: "맛스타", myPlanet: Planet.testUserPlanet, satellites: Planet.testUserSatellites)
//    }()
//}
