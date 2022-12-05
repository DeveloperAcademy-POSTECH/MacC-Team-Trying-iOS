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
    var myPlanet: UserInfoDTO.Planet?
    let satellites: [UserInfoDTO.Planet]
    var myCourses: [UserCourseInfoDTO.Course?]
    
    init(nickName: String, myPlanet: UserInfoDTO.Planet?, myCourses: [UserCourseInfoDTO.Course?]) {
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
