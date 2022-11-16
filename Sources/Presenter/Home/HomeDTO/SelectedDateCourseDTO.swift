//
//  SelectedDateCourseDTO.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct SelectedDateCourseDTO: Codable {
    let courseId: Int
    let title, date: String
    let liked: Bool
    let places: [PlaceElement]
    
    // MARK: - PlaceElement
    struct PlaceElement: Codable {
        let memo: String
        let place: PlacePlace
        let distanceFromNext: Double?
    }

    // MARK: - PlacePlace
    struct PlacePlace: Codable {
        let placeId: Int
        let name, address, roadAddress: String
        let coordinate: Coordinate
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let latitude, longitude: Double
    }
}
