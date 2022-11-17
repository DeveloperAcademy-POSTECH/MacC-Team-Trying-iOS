//
//  PlaceSearchResponse.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

struct PlaceSearchResponse: Decodable {
    let contents: [Content]
    let size: Int
    let hasNext: Bool
    
    struct Content: Decodable {
        let place: ResponsePlace
        let distance: Double
        
        struct ResponsePlace: Decodable {
            let placeId: Int
            let name: String
            let coordinate: Coordinate
            
            struct Coordinate: Decodable {
                let latitude: CLLocationDegrees
                let longitude: CLLocationDegrees
            }
        }
    }
}
