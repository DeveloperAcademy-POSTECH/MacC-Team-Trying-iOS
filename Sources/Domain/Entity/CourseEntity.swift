//
//  CourseEntity.swift
//  ComeItTests
//
//  Created by 김승창 on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct CourseEntity {
    let id: Int
    let courseTitle: String
    let date: String
    var isLike: Bool
    var places: [PlaceEntity]
}
