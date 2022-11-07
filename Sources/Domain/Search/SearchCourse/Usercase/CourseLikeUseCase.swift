//
//  CourseLikeUseCase.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/29.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol LikeTogglableDelegate {
    func courseLikeToggle(courseId: Int, isLike: Bool)
}

class CourseLikeUseCase: LikeTogglableDelegate {
    
    private let courseToggleImpl: CourseToggleInterface
    
    init(courseToggleImpl: CourseToggleInterface) {
        self.courseToggleImpl = courseToggleImpl
    }
    
    func courseLikeToggle(courseId: Int, isLike: Bool) {
        courseToggleImpl.courseLikeToggle(courseId: courseId, isLike: isLike)
    }
}
