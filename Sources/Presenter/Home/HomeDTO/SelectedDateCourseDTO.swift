//
//  SelectedDateCourseDTO.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

// MARK: - Welcome
struct SelectedDateCourseDTO: Codable {
    let courseId: Int
    let title, date: String
    let liked: Bool
    let places: [PlaceElement]
    // MARK: - PlaceElement
    struct PlaceElement: Codable {
        let place: PlacePlace
        let memo: String?
        let distanceFromNext: Double?
    }

    // MARK: - PlacePlace
    struct PlacePlace: Codable {
        let placeId, identifier: Int
        let name, category, address: String
        let coordinate: Coordinate
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let longitude, latitude: Double
    }
}
