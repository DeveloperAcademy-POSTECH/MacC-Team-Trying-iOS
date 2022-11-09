//
//  HomeViewModel.swift
//  MatStar
//
//  Created by uiskim on 2022/10/12.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine
import CoreLocation

struct DateDday {
    let title: String
    let dday: Int
}

struct DatePath {
    let title: String
    let comment: String
    let distance: Int?
    let location: CLLocationCoordinate2D
}

final class HomeViewModel: BaseViewModel {
    
    let ddayDateList = [
        DateDday(title: "인천데이트", dday: 10),
        DateDday(title: "부산데이트", dday: 20),
        DateDday(title: "강릉데이트", dday: 30),
        DateDday(title: "서울데이트", dday: 40)
    ]
    
    let datePathList: [DatePath] = [
        DatePath(
            title: "삐갈레브레드",
            comment: "10시오픈, 소금빵 꼭 먹기",
            distance: 500,
            location: CLLocationCoordinate2D(latitude: 36.008156565588024, longitude: 129.3302379630373)
        ),
        DatePath(
            title: "효자동쌀국수",
            comment: "아롱사태 국수추천, 주차할곳 없음",
            distance: 700,
            location: CLLocationCoordinate2D(latitude: 36.00807426131621, longitude: 129.3299527646833)
        ),
        DatePath(
            title: "바르벳",
            comment: "아이스아메리카노 맛집",
            distance: 1100,
            location: CLLocationCoordinate2D(latitude: 36.00973547648496, longitude: 129.33325365316696)
        ),
        DatePath(
            title: "철길숲",
            comment: "불의정원보기",
            distance: 300,
            location: CLLocationCoordinate2D(latitude: 36.012325953577815, longitude: 129.34087386842018)
        ),
        DatePath(
            title: "포항공대",
            comment: "e콜맥",
            distance: nil,
            location: CLLocationCoordinate2D(latitude: 36.01574093017324, longitude: 129.32245135107428)
        )
    ]
    
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
}
