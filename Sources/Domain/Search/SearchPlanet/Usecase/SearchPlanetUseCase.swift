//
//  SearchPlanetUseCase.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

protocol SearchableDelegate: AnyObject {
    func execute (searchType: SearchType, planetName: String, page: Int, isFirst: Bool) -> AnyPublisher<([Searchable], Bool), Error>
}

final class SearchPlanetUseCase: SearchableDelegate {

    private let planetRepositoryImpl: SearchPlanetCourseRepository
    
    init(planetRepository: SearchPlanetCourseRepository) {
        self.planetRepositoryImpl = planetRepository
    }
    
    func execute(searchType: SearchType, planetName: String, page: Int, isFirst: Bool) -> AnyPublisher<([Searchable], Bool), Error> {
        
        switch searchType {
        case .course:
            let coursePublisher = planetRepositoryImpl.fetchPlanetsCourses(
                searchType: searchType,
                planetName: planetName,
                page: page,
                isFirst: isFirst
            )
            as AnyPublisher<CourseResponse, Error>
            return coursePublisher
                .map { courseResponse -> ([SearchCourse], Bool) in
                    (courseResponse.courses.map { 
                        .init(
                              planetImageString: $0.planet.image,
                              planetNameString: $0.planet.name,
                              timeString: $0.createdDate,
                              locationString: "장소",
                              isLike: $0.liked,
                              imageURLStrings: $0.images,
                              courseId: $0.courseID
                        )
                    },
                     courseResponse.hasNext)
                }
                .eraseToAnyPublisher()
            
        case .planet:
            let planetPublisher = planetRepositoryImpl.fetchPlanetsCourses(
                searchType: searchType,
                planetName: planetName,
                page: page,
                isFirst: isFirst
            )
            as AnyPublisher<PlanetsResponse, Error>
            
            return planetPublisher
                .map { searchResponse -> ([SearchPlanet], Bool) in
                    (searchResponse.planets.map {
                        .init(
                              planetId: $0.planetID,
                              planetImageString: $0.image,
                              planetNameString: $0.name,
                              isFollow: $0.followed ?? false,
                              hosts: ["not yet", "not yet"])
                    },
                     searchResponse.hasNext
                    )
                }
                .eraseToAnyPublisher()
        }
    }
}
