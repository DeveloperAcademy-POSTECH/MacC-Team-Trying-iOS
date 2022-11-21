//
//  EditCourseRequest.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

struct EditCourseRequest: Encodable {
    let title: String
    let date: String
    let places: [Place]
    
    struct Place: Encodable {
        let place: PlaceElement
        let memo: String?
        
        struct PlaceElement: Encodable {
            let identifier: Int
            let name: String
            let category: String
            let address: String
            let latitude: CLLocationDegrees
            let longitude: CLLocationDegrees
        }
    }
}
