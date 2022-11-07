//  SearchCourse.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/28.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct SearchCourse: Searchable {
    let planetImageString: String
    let planetNameString: String
    let timeString: String
    let locationString: String
    var isLike: Bool
    let imageURLStrings: [String]
    let courseId: Int
}
