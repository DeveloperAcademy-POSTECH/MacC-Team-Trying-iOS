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
                    (courseResponse.courses.map { course in
                        .init(
                              planetImageString: course.planet.image,
                              planetNameString: course.planet.name,
                              timeString: course.createdDate,
                              locationString: "장소",
                              isLike: course.liked,
                              imageURLStrings: course.images,
                              courseId: course.courseID
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
                    (searchResponse.planets.map { planet in
                        .init(
                              planetId: planet.planetID,
                              planetImageString: planet.image,
                              planetNameString: planet.name,
                              isFollow: planet.followed ?? false,
                              hosts: ["not yet", "not yet"]
                        )
                    },
                     searchResponse.hasNext
                    )
                }
                .eraseToAnyPublisher()
        }
    }
}
