//
//  SearchViewModel.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/20.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import CancelBag

final class SearchViewModel: BaseViewModel {
    
    @Published var currentCategory: CoursePlanet = .course
    @Published var coursesOrPlanets = []
    
    @Published private var courses = []
    @Published private var planets = []
    
    @Published var searchString: String
    
    private var searchPlanetUseCase: SearchableDelegate
    private var courseLikeUseCase: LikeTogglableDelegate
    private var planetFollowUseCase: FollowTogglableDelegate
    
    private var countOfItem = 0
    private var canFetch: Bool = false
    private var currentPage: Int = 0
    private var modifiedLikedDictionary: [Int: Bool] = [:]
    private var modifiedFollowDictionary: [Int: Bool] = [:]
    
    override init() {
        searchString = ""
        self.searchPlanetUseCase = SearchPlanetUseCase(planetRepository: SearchPlanetRepository())
        self.courseLikeUseCase = CourseLikeUseCase(courseToggleImpl: CourseLikeRepository())
        self.planetFollowUseCase = PlanetFollowUseCase(planetToggleImpl: PlanetFollowRepository())
        super.init()
        bind()
    }
    
    func changeTo(_ coursePlanet: CoursePlanet) {
        guard self.currentCategory != coursePlanet else { return }
        coursesOrPlanets = []
        currentCategory = coursePlanet
    }
    
    func prefetchIndexAt(_ index: Int?) {
        
        guard let index = index else {
            return
        }
        if index + 10 >= countOfItem {
            if canFetch {
                currentPage += 1
                switch currentCategory {
                case .course:
                    fetchCourses(searchString, page: currentPage)
                case .planet:
                    fetchPlanets2(searchString, page: currentPage)
                }
                canFetch.toggle()
            }
        }
    }
    
    private func bind() {
        $searchString
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .compactMap { $0 }
            .sink { str in
                self.coursesOrPlanets = []
                self.currentPage = 0
                self.countOfItem = 0
                switch self.currentCategory {
                case .course:
                    self.fetchCourses(str, page: 0, isFirst: true)
                case .planet:
                    self.fetchPlanets2(str, page: 0, isFirst: true)
                    
                }
            }
            .cancel(with: cancelBag)
    
        $currentCategory
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { coursePlanet in
                self.coursesOrPlanets = []
                self.currentPage = 0
                self.countOfItem = 0
                switch coursePlanet {
                case .course:
                    self.fetchCourses(self.searchString, page: 0, isFirst: true)
                case .planet:
                    self.fetchPlanets2(self.searchString, page: 0, isFirst: true)
                }
            }
            .cancel(with: cancelBag)
        
        Publishers.Merge($planets, $courses)
            .sink { infos in
                self.coursesOrPlanets += infos
                self.countOfItem = self.coursesOrPlanets.count
            }
            .cancel(with: cancelBag)
    }
}

extension SearchViewModel {
    func fetchPlanets2(_ planetName: String, page: Int, isFirst: Bool = false) {
        searchPlanetUseCase.execute(searchType: .planet, planetName: planetName, page: page, isFirst: isFirst)
            .sink { _ in
            } receiveValue: { response in
                self.planets = response.0
                self.canFetch = response.1
            }
            .cancel(with: cancelBag)
    }
}

extension SearchViewModel {
    
    func fetchCourses(_ courseName: String, page: Int, isFirst: Bool = false) {
        searchPlanetUseCase.execute(searchType: .course, planetName: courseName, page: page, isFirst: isFirst)
            .sink { _ in
            } receiveValue: { response in
                self.courses = response.0
                guard let coursess = self.courses as? [SearchCourse] else { return }
                self.canFetch = response.1
            }
            .cancel(with: cancelBag)
    }
}

extension SearchViewModel {
    func toggleLike(courseId: Int, isLike: Bool) {
        courseLikeUseCase.courseLikeToggle(courseId: courseId, isLike: isLike)
        modifiedLikedDictionary.updateValue(isLike, forKey: courseId)
    }
    
    func toggleFollow(planetId: Int, isFollow: Bool) {
        planetFollowUseCase.courseLikeToggle(planetId: planetId, isFollow: isFollow)
        modifiedFollowDictionary.updateValue(isFollow, forKey: planetId)
    }
    
    func getCourseIndexPathAt(_ indexPath: IndexPath) -> SearchCourse? {
        guard let course = coursesOrPlanets[indexPath.row] as? SearchCourse else { return nil }
        return SearchCourse(
            planetImageString: convertToProperImageString(course.planetImageString),
            planetNameString: course.planetNameString,
            timeString: course.timeString,
            locationString: course.locationString,
            isLike: modifiedLikedDictionary[course.courseId] ?? course.isLike,
            imageURLStrings: course.imageURLStrings,
            courseId: course.courseId
        )
    }
    
    func getPlanetIndexPathAt(_ indexPath: IndexPath) -> SearchPlanet? {
        guard let planet = coursesOrPlanets[indexPath.row] as? SearchPlanet else { return nil }
        return SearchPlanet(
            planetId: planet.planetId,
            planetImageString: convertToProperImageString(planet.planetImageString),
            planetNameString: planet.planetNameString,
            isFollow: modifiedFollowDictionary[planet.planetId] ?? planet.isFollow,
            hosts: planet.hosts
        )
    }
}

extension SearchViewModel {
    //TODO: enum
    private func convertToProperImageString(_ string: String) -> String {
        if string == "EARTH" {
            return "img_planet"
        } else if string == "planet" {
            return "img_planet2"
        } else {
            return "img_planet3"
        }
    }
}
extension SearchViewModel {
    func bind(_ textField: UITextField, to property: ReferenceWritableKeyPath<SearchViewModel, String>) {
            NotificationCenter.default.publisher(for: UITextField.textDidChangeNotification, object: textField)
                 .sink(receiveValue: { result in
                     if let textField = result.object as? UITextField {
                         self[keyPath: property] = textField.text ?? ""
                     }
                 })
                 .cancel(with: cancelBag)
        }
}

enum CoursePlanet: Int, CaseIterable {
    case course
    case planet
}
