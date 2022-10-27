//
//  InquiryMyCouresDTO.swift
//  MatStar
//
//  Created by uiskim on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct UserCourseInfo: Codable {
    let courses: [Course]
    let size: Int
    let hasNext: Bool
    
    // MARK: - Course
    struct Course: Codable {
        let courseId: Int
        let createdDate, title: String
        let coordinates: [Coordinates]
    }

    // MARK: - Star
    struct Coordinates: Codable {
        let latitude, longitude: Double
    }
}
