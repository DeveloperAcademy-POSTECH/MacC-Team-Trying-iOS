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

struct HomeCourse {
    let courseTitle: String
    let courseList: [DatePath]
}

struct DatePath {
    let title: String
    let comment: String
    let distance: Double?
    let location: CLLocationCoordinate2D
}

//struct TestUser {
//    let hasMate: Bool
//    // MARK: - 무조건 생성날짜기준으로는 defalt값이 존재하므로 optional아님
//    let dday: Int
//    let hasNewAlarm: Bool
//}

final class HomeViewModel: BaseViewModel {

    @Published var user: UserInfo?
    @Published var dateCalendarList: [YearMonthDayDate] = []
    @Published var dateCourse: HomeCourse?
    
    let ddayDateList = [
        DateDday(title: "인천데이트", dday: 10),
        DateDday(title: "부산데이트", dday: 20),
        DateDday(title: "강릉데이트", dday: 30),
        DateDday(title: "서울데이트", dday: 40)
    ]

    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
    
    func fetchUserInfo() async throws {
        let data = try await HomeAPIService.fetchUserAsync(tokenType: .hasMate)
        guard let myPlanineInfoDTO = try? JSONDecoder().decode(UserInfo.self, from: data) else {
             print("Decoder오류")
             return
         }
        self.user = myPlanineInfoDTO
    }
    
    func fetchDateRange(dateRange: [String]) async throws {
        
        let data = try await HomeAPIService.fetchDateList(startDate: dateRange[0], endDate: dateRange[1])
        guard let myDateListDTO = try? JSONDecoder().decode(DateList.self, from: data) else {
            print("데이트날짜 범위 조회 Decoder오류")
            return
        }
        
        dateCalendarList = myDateListDTO.dates
            .map { $0.getDateFromString() }
            .map { YearMonthDayDate(year: $0.year, month: $0.month, day: $0.day) }
    }
    
    func hasCourse(selectedDate: String) -> Bool {
        guard let selectedDate = selectedDate.toDate() else { return false }
        return dateCalendarList.map { $0.asDate() }.contains(selectedDate)
    }
    
    func fetchSelectedDateCourse(selectedDate: String) async throws {
        
        let data = try await HomeAPIService.fetchCourseList(selectedDate: selectedDate)
        guard let selectedDateCourseDTO = try? JSONDecoder().decode(SelectedDateCourse.self, from: data) else {
            print("선택한 날짜 데이트 코스 조회 Decoder오류")
            return
        }
        let placeList: [DatePath] = selectedDateCourseDTO.places.map { placeElement in
            DatePath(title: placeElement.place.name, comment: placeElement.memo, distance: placeElement.distanceFromNext, location: .init(latitude: CLLocationDegrees(floatLiteral: placeElement.place.coordinate.latitude), longitude: CLLocationDegrees(floatLiteral: placeElement.place.coordinate.longitude)))
        }
        dateCourse = HomeCourse(courseTitle: selectedDateCourseDTO.title, courseList: placeList)
    }
}
