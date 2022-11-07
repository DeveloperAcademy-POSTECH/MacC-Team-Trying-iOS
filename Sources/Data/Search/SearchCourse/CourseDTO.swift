//
//  CourseDTO.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/28.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct CourseResponse: Decodable {
    let courses: [CourseDTO]
    let size: Int
    let hasNext: Bool
}

struct CourseDTO: Codable {
    let courseID: Int
    let planet: PlanetDTO
    let title, createdDate: String
    let liked: Bool
    let images: [String]

    enum CodingKeys: String, CodingKey {
        case courseID = "courseId"
        case planet, title, createdDate, liked, images
    }
}
