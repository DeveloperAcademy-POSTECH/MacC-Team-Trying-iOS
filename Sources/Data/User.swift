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
    var myPlanet: UserInfo.Planet?
    let satellites: [UserInfo.Planet]
    var myCourses: [UserCourseInfo.Course?]
    
    init(nickName: String, myPlanet: UserInfo.Planet?, myCourses: [UserCourseInfo.Course?]) {
        self.email = ""
        self.password = ""
        self.nickName = nickName
        self.myPlanet = myPlanet
        self.satellites = []
        self.myCourses = myCourses
    }
}

//extension User {
//    static let testUser: User = {
//        .init(email: "matStar1015@gmail.com", password: "matStar1015", nickName: "맛스타", myPlanet: Planet.testUserPlanet, satellites: Planet.testUserSatellites)
//    }()
//}
