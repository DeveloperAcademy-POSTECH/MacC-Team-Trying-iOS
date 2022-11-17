//
//  UserEntity.swift
//  ComeItTests
//
//  Created by 김승창 on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct UserEntity {
    let id: Int
    let email: String?
    let password: String
    let nickName: String
    let myPlanet: PlanetEntity
    var likeCourses: [CourseEntity]
}
