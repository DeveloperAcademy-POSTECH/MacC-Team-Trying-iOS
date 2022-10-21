//
//  SearchViewModel.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/20.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

import UIKit

final class SearchViewModel: BaseViewModel {
    
    @Published var currentCategory: CoursePlanet = .course
    @Published var coursesOrPlanets = []
    
    @Published private var courses = []
    @Published private var planets = []
    
    var cancelbag = Set<AnyCancellable>()
    
    override init() {
        super.init()
        bind()
    }
    
    func changeTo(_ coursePlanet: CoursePlanet) {
        guard self.currentCategory != coursePlanet else { return }
        coursesOrPlanets = []
        currentCategory = coursePlanet
    }
    
    private func bind() {
        
        $currentCategory
            .sink { coursePlanet in
                switch coursePlanet {
                case .course:
                    self.fetchCourses()
                case .planet:
                    self.fetchPlanets()
                }
            }
            .store(in: &cancelbag)
        
        Publishers.Merge($planets, $courses)
            .sink { infos in
                self.coursesOrPlanets = infos
            }
            .store(in: &cancelbag)
    }
}

extension SearchViewModel {
    
    func fetchCourses() {
        //MARK: 임시 데이터 타입입니다.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            guard self.currentCategory == .course else { return }
            self.courses = [
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: false, isLike: true, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]),
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: false, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]),
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: false, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"]),
                SearchCourse(planetImageString: "MyPlanetImage", planetNameString: "한규행성", timeString: "32분 전", locationString: "한규", isFollow: false, isLike: false, imageURLStrings: ["picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample", "picture_sample"])
            ]
        }
    }
    
    func fetchPlanets() {
        //MARK: 임시 데이터 타입입니다.
        DispatchQueue.global().asyncAfter(deadline: .now() + 1) {
            guard self.currentCategory == .planet else { return }
            self.planets = [SearchPlanet(planetImageString: "MyPlanetImage", planetNameString: "한규행성", isFollow: true, hosts: ["이한규", "엠마왔쓴"]),SearchPlanet(planetImageString: "MyPlanetImage", planetNameString: "한규행성", isFollow: true, hosts: ["이한규", "엠마왔쓴"])]
        }
        
    }
}

//MARK: 임시 데이터 타입입니다.
struct SearchCourse {
    //TODO: TestViewController 바꾸고 올리기
    let planetImageString: String
    let planetNameString: String
    let timeString: String
    let locationString: String
    let isFollow: Bool
    let isLike: Bool
    let imageURLStrings: [String]
}

struct SearchPlanet {
    //TODO: TestViewController 바꾸고 올리기
    let planetImageString: String
    let planetNameString: String
    let isFollow: Bool
    let hosts: [String]
}

