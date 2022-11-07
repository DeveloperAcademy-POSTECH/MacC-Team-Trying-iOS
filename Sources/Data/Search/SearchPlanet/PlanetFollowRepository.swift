//
//  PlanetFollowRepository.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/30.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

class PlanetFollowRepository: PlanetToggleInterface {
    
    private let searchAPIService: SearchAPI
    
    init(searchAPI: SearchAPI = SearchAPI()) {
        self.searchAPIService = searchAPI
    }
    
    func planetFollowToggle(planetId: Int, isFollow: Bool) {
        searchAPIService.planetFollowToggle(planetId: planetId, isFollow: isFollow)
    }
}
