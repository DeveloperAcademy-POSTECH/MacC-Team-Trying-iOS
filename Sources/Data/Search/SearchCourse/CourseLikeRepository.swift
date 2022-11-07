//
//  CourseLikeRepository.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/29.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

class CourseLikeRepository {
    
    private let searchAPIService: SearchAPI
    
    init(searchAPI: SearchAPI = SearchAPI()) {
        self.searchAPIService = searchAPI
    }
}

extension CourseLikeRepository: CourseToggleInterface {
    func courseLikeToggle(courseId: Int, isLike: Bool) {
        searchAPIService.courseLikeToggle(courseId: courseId, isLike: isLike)
    }
}
