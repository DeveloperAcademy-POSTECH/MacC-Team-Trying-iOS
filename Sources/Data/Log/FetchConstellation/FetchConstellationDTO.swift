//
//  ConstellationRequestDTO.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation

struct FetchConstellationDTO: Codable {
    let courses: [Course]
    let size: Int
    let hasNext: Bool

    // MARK: - Course
    struct Course: Codable {
        let courseId: Int
        let title: String
        let date: String
        let liked: Bool
        let places: [PlaceElement]
    }
    
    // MARK: - PlaceElement
    struct PlaceElement: Codable {
        let memo: String?
        let place: Place
        let distanceFromNext: Double?
    }
    
    // MARK: - PlacePlace
    struct Place: Codable {
        let placeId: Int
        let name : String
        let coordinate: Coordinate
    }

    // MARK: - Coordinate
    struct Coordinate: Codable {
        let latitude, longitude: CLLocationDegrees
    }
}
