//
//  AlarmCourseIdDTO.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct AlarmCourseIdDTO: Codable {
    let courseID: Int
    let title, date: String
    let liked: Bool
    let places: [PlaceElement]

    enum CodingKeys: String, CodingKey {
        case courseID = "courseId"
        case title, date, liked, places
    }
}

// MARK: - PlaceElement
struct PlaceElement: Codable {
    let place: PlaceArea
    let memo: String
    let distanceFromNext: Double?
}

// MARK: - PlacePlace
struct PlaceArea: Codable {
    let placeID: Int
    let name: String
    let coordinate: Coordinate

    enum CodingKeys: String, CodingKey {
        case placeID = "placeId"
        case name, coordinate
    }
}

// MARK: - Coordinate
struct Coordinate: Codable {
    let longitude, latitude: Double
}
