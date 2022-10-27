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
        let data = try await HomeAPIService.fetchUserAsync(accessToken: accessToken)
        guard let myPlanineInfoDTO = try? JSONDecoder().decode(UserInfo.self, from: data) else {
            print("Decoder오류")
            return
        }
        let courseData = try await HomeAPIService.fetchUserCourseAsync(planetId: myPlanineInfoDTO.planet?.planetId)
        guard let myCourseInfoDTO = try? JSONDecoder().decode(UserCourseInfo.self, from: courseData) else {
            print("Course Decoder오류")
            return
        }
//        self.constellations = [
//            Constellation(name: "창원 야구장", data: "2022-10-01(토)", image: UIImage(named: "Changwon")),
//            Constellation(name: "광안대교 야경", data: "2022-10-02(일)", image: UIImage(named: "Busan")),
//            Constellation(name: "포항공대", data: "2022-10-03(월)", image: UIImage(named: "Pohang")),
//            Constellation(name: "부산", data: "2022-10-04(화)", image: UIImage(named: "Busan")),
//            Constellation(name: "애플아카데미", data: "2022-10-05(수)", image: UIImage(named: "Pohang")),
//            Constellation(name: "포항", data: "2022-10-06(목)", image: UIImage(named: "Pohang")),
//            Constellation(name: "부산대학교", data: "2022-10-07(금)", image: UIImage(named: "Busan")),
//            Constellation(name: "인천ssg파크", data: "2022-10-08(토)", image: UIImage(named: "Pohang"))
//        ]
        self.user = User(nickName: myPlanineInfoDTO.me.name, myPlanet: myPlanineInfoDTO.planet, myCourses: myCourseInfoDTO.courses)
    }
    
    // MARK: completion Handler(urlsession)로 호출한 api
//    func fetch(completion: @escaping (User) -> Void ) {
//        HomeAPIService.fetchUser { [weak self] result in
//            switch result {
//            case .success(let data):
//                do {
//                    guard let myPlanineInfoDTO = try? JSONDecoder().decode(UserInfo.self, from: data) else {
//                        return print("gg")
//                    }
//                    completion(User(nickName: myPlanineInfoDTO.me.name))
//                } catch {
//                    print("디코딩실패")
//                }
//
//            case .failure(let failure):
//                print(failure)
//            }
//        }
//    }

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
