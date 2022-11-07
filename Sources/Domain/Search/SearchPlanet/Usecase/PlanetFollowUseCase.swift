//
//  PlanetFollowUseCase.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/30.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol FollowTogglableDelegate: AnyObject {
    func courseLikeToggle(planetId: Int, isFollow: Bool)
}

class PlanetFollowUseCase: FollowTogglableDelegate {
    
    private let planetToggleImpl: PlanetToggleInterface
    
    init(planetToggleImpl: PlanetToggleInterface) {
        self.planetToggleImpl = planetToggleImpl
    }
    
    func courseLikeToggle(planetId: Int, isFollow: Bool) {
        planetToggleImpl.planetFollowToggle(planetId: planetId, isFollow: isFollow)
    }
}
