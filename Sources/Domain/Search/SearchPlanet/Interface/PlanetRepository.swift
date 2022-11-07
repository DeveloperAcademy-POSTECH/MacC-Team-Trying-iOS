//
//  Interface.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

enum SearchType {
    case course
    case planet
}

protocol Searchable: Decodable { }
protocol SearchPlanetCourseRepository {
    func fetchPlanetsCourses<T: Decodable>(searchType: SearchType, planetName: String, page: Int, isFirst: Bool) -> AnyPublisher<T, Error>
}

protocol PlanetToggleInterface {
    func planetFollowToggle(planetId: Int, isFollow: Bool)
}
