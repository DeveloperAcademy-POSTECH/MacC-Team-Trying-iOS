//
//  SearchPlanetRepository.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

class SearchPlanetRepository {
    
    private let searchAPIService: SearchAPI
    
    init(searchAPI: SearchAPI = SearchAPI()) {
        self.searchAPIService = searchAPI
    }
}

extension SearchPlanetRepository: SearchPlanetCourseRepository {
    func fetchPlanetsCourses<T>(searchType: SearchType, planetName: String, page: Int, isFirst: Bool) -> AnyPublisher<T, Error> where T: Decodable {
        searchAPIService.getDataWithCombineSongs(searchType: searchType, parameter: planetName, page: page, isFirst: isFirst)
    }

}
