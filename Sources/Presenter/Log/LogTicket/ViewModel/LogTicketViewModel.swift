//
//  LogTicketViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Modified by 정영진 on 2022/10/21
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation

final class LogTicketViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
        fetchData()
    }
    
    var data: TestModel?
    // TODO: MOCK용 임시 함수
    func fetchData() {
        self.data = TestModel(
            id: 1,
            planet: "우디네 행성",
            planetImage: "woodyPlanetImage",
            title: "부산풀코스",
            body: "배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이  온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이  온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이  온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이  온다.배가 많이 고프다, 잠이 온다.배가 많이 고프다, 잠이 온다.",
            date: "2022년 10월 20일",
            tag: ["삐갈레브레드", "포항공과대학교", "귀여운승창이"],
            images: ["KyuandWoody", "lakeImage", "KyuandWoody", "lakeImage"]
        )
    }
    
    func tapDismissButton() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func tapLikeButton() {
        // TODO: UI 수정되어야하고 API 호출
    }
    
    func tapFlopButton() {
        // TODO: 카드가 뒤집히는 애니매이션
    }
}

// MARK: MOCK
struct TestModel {
    let id: Int
    let planet: String
    let planetImage: String
    let title: String
    let body: String
    let date: String
    let tag: [String]
    let images: [String]
}
