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
    
    override init() {
        searchString = ""
        super.init()
        bind()
    }
    
    func changeTo(_ coursePlanet: CoursePlanet) {
        guard self.currentCategory != coursePlanet else { return }
        coursesOrPlanets = []
        currentCategory = coursePlanet
    }
    
    private func bind() {
        
        $searchString
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .removeDuplicates()
            .dropFirst()
            .compactMap { $0 }
            .sink { str in
                print("call")
                switch self.currentCategory {
                case .course:
                    self.fetchCourses(str)
                case .planet:
                    self.fetchPlanets(str)
                }
            }
            .cancel(with: cancelBag)
    
        $currentCategory
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .sink { coursePlanet in
                switch coursePlanet {
                case .course:
                    self.fetchCourses(self.searchString)
                case .planet:
                    self.fetchPlanets(self.searchString)
                }
            }
            .cancel(with: cancelBag)
        
        Publishers.Merge($planets, $courses)
            .sink { infos in
                self.coursesOrPlanets = infos
            }
            .cancel(with: cancelBag)
    }
}

extension SearchViewModel {
    
    func fetchCourses(_ string: String) {
        //MARK: 임시 데이터 타입입니다.
            guard self.currentCategory == .course else { return }
            self.courses = ([
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: false, isLike: true, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]),
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "두규", isFollow: false, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]),
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "세규", isFollow: false, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]),
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "네규", isFollow: false, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"])
            ] as [SearchCourse])
            .filter { $0.locationString.contains(string) }
    }
    
    func fetchPlanets(_ string: String) {
        //MARK: 임시 데이터 타입입니다.
            guard self.currentCategory == .planet else { return }
            self.planets = ([
                SearchPlanet(planetImageString: "MyPlanetImage", planetNameString: "두규행성", isFollow: true, hosts: ["이한규", "엠마왔쓴"]),
                SearchPlanet(planetImageString: "MyPlanetImage", planetNameString: "규한행성", isFollow: true, hosts: ["이한규", "엠마왔쓴"])
            ] as [SearchPlanet])
            .filter { $0.planetNameString.contains(string) }
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

//MARK: 임시 데이터 타입입니다.
struct SearchCourse {
    let planetImageString: String
    let planetNameString: String
    let timeString: String
    let locationString: String
    let isFollow: Bool
    let isLike: Bool
    let imageURLStrings: [String]
}

struct SearchPlanet {
    let planetImageString: String
    let planetNameString: String
    let isFollow: Bool
    let hosts: [String]
}
