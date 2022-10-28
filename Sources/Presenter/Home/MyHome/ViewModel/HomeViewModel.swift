//
//  HomeViewModel.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

protocol AlarmViewCoordinating {
    func pushToAlarmViewController()
}

protocol CourseDetailCoordinating {
    func pushToCourseDetailViewController()
}
struct Constellation {
    let name: String
    let data: String
    let image: UIImage?
}

final class HomeViewModel: BaseViewModel {
    
    private let domain: String = "http://15.165.72.196:3059/users/me"
    
    var user: User?

    var coordinator: Coordinator
    
    var hasMate = true
    
    var constellations: [Constellation] = []
    
    var planets: [Planet] = [
        Planet(planetId: 1, name: "우디", planetTyle: .red, createdDate: "우디행성 입니다"),
        Planet(planetId: 2, name: "유스", planetTyle: .purple, createdDate: "유스행성 입니다"),
        Planet(planetId: 3, name: "포딩", planetTyle: .pink, createdDate: "포딩행성 입니다"),
        Planet(planetId: 4, name: "찰리", planetTyle: .orange, createdDate: "찰리행성 입니다"),
        Planet(planetId: 5, name: "루미", planetTyle: .pink, createdDate: "루미행성 입니다")
    ]
    
    var loction: [CGPoint] = [
        CGPoint(x: 50, y: 210),
        CGPoint(x: 175, y: 186),
        CGPoint(x: 319, y: 276),
        CGPoint(x: 58, y: 566),
        CGPoint(x: 254, y: 555)
    ]    
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    // MARK: async로 호출한 api함수
    func fetchAsync() async throws {
        guard let accessToken = UserDefaults.standard.string(forKey: "accessToken") else { return }
        let data = try await HomeAPIService.fetchUserAsync(accessToken: token)
        guard let myPlanineInfoDTO = try? JSONDecoder().decode(UserInfo.self, from: data) else {
            print("Decoder오류")
            return
        }
        let courseData = try await HomeAPIService.fetchUserCourseAsync(planetId: 27)
        guard let myCourseInfoDTO = try? JSONDecoder().decode(UserCourseInfo.self, from: courseData) else {
            print("Course Decoder오류")
            return
        }
        self.user = User(nickName: myPlanineInfoDTO.me.name, myPlanet: myPlanineInfoDTO.planet, myCourses: myCourseInfoDTO.courses)
    }
    
    func pushToAlarmView() {
        guard let coordinator = coordinator as? AlarmViewCoordinating else { return }
        coordinator.pushToAlarmViewController()
    }
    
    func pushToCourseDetailView() {
        guard let coordinator = coordinator as? CourseDetailCoordinating else { return }
        coordinator.pushToCourseDetailViewController()
    }

    func startAddCourseFlow() {
        guard let coordinator = coordinator as? HomeCoordinator else { return }
        coordinator.startAddCourseFlow()
    }
}
