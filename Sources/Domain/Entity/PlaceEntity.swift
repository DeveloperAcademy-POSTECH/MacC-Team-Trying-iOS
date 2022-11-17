//
//  PlaceEntity.swift
//  ComeItTests
//
//  Created by 김승창 on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

struct PlaceEntity {
    let id: Int
    let title: String
    let category: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    var memo: String?
}
