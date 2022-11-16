//
//  LogHomeViewModel.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation

protocol TicketViewCoodinating {
    func presentTicketViewController()
}
protocol MyConstellationViewCoordinating {
    func pushMyConstellationViewController()
}
protocol LogMapViewCoordinating {
    func pushLogMapViewController()
}

// MARK: ViewModel
final class LogHomeViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    private let fetchConstellationsUseCase: FetchConstellationsUseCase
    
    var courses = [TestCourse]()
    
    init(
        coordinator: Coordinator,
        fetchConstellationUseCase: FetchConstellationsUseCase = FetchConstellationsUseCaseImpl()
    ) {
        self.coordinator = coordinator
        self.fetchConstellationsUseCase = fetchConstellationUseCase
        super.init()
        fetchData()
    }
}

extension LogHomeViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushMyConstellationView() {
        guard let coordinator = coordinator as? MyConstellationViewCoordinating else { return }
        coordinator.pushMyConstellationViewController()
    }
    
    func presentTicketView() {
        guard let coordinator = coordinator as? TicketViewCoodinating else { return }
        coordinator.presentTicketViewController()
    }
    
    func pushLogMapViewController() {
        guard let coordinator = coordinator as? LogMapViewCoordinating else { return }
        coordinator.pushLogMapViewController()
    }
}

// TODO 삭제할 코드
struct TestCourse {
    let places: [Place]
    let courseName: String
    let date: String
}

extension LogHomeViewModel {
    func fetchData() {
        for _ in 0...7 {
            let mockCourse = TestCourse(
                places: [
                    Place(
                        title: "광안리해수욕장",
                        category: "해수욕장",
                        address: "부산 남구 대연동",
                        location: CLLocationCoordinate2D(latitude: 1, longitude: 1),
                        memo: "테스트 메모"
                    ),
                    Place(
                        title: "H에비뉴호텔",
                        category: "호텔",
                        address: "서울특별시 어딘가",
                        location: CLLocationCoordinate2D(latitude: 3, longitude: 1),
                        memo: nil
                    ),
                    Place(
                        title: "널구지공원",
                        category: "공원",
                        address: "충북 서산시 어딘가",
                        location: CLLocationCoordinate2D(latitude: 2, longitude: 3),
                        memo: "테스트 메모"
                    ),
                    Place(
                        title: "금련산",
                        category: "산",
                        address: "경북 포항시 북구 창포동",
                        location: CLLocationCoordinate2D(latitude: 4, longitude: 2),
                        memo: nil
                    )
                ],
                courseName: "루미네 집 구경",
                date: "2022년 11월 10일"
            )
            self.courses.append(mockCourse)
        }
    }
}
