//
//  PlanetEntity.swift
//  ComeItTests
//
//  Created by 김승창 on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

struct PlanetEntity {
    let id: Int
    let name: String
    let planetImage: UIImage
    let createDate: Date
    var courses: [CourseEntity]
}
