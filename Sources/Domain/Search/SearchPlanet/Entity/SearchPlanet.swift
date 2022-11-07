//
//  SearchPlanet.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct SearchPlanet: Searchable {
    let planetId: Int
    let planetImageString: String
    let planetNameString: String
    let isFollow: Bool
    let hosts: [String]
}
