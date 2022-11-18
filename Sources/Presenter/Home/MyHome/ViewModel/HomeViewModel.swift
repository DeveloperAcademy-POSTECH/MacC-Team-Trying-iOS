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

final class HomeViewModel: BaseViewModel {

    @Published var user: UserInfoDTO?
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
        guard let myUserInfo = try? JSONDecoder().decode(UserInfoDTO.self, from: data) else {
             print("Decoder오류")
             return
         }
        self.user = myUserInfo
    }
    
    /// 현재 11월이라면 10월01일 ~ 12월01일을 범위로 주면 10월 01일부터 11월31일까지의 날짜중에 date가 존재하는 날짜를 반환해주는 함수
    /// - Parameter dateRange: 월범위가 존재
    func fetchDateRange(dateRange: [String]) async throws {
        let data = try await HomeAPIService.fetchDateList(dateRange: dateRange)
        guard let myDateListDTO = try? JSONDecoder().decode(DateList.self, from: data) else {
            print("데이트날짜 범위 조회 Decoder오류")
            return
        }
        
        dateCalendarList = myDateListDTO.dates
            .map { $0.getDateFromString() }
            .map { YearMonthDayDate(year: $0.year, month: $0.month, day: $0.day) }
    }
    
    /// 코스가 존재하는지 존재하지 않는지 여부를 판단하는 함수
    /// - Parameter selectedDate: 캘린더에서 내가 누른 날짜
    /// - Returns: 내가누른 날짜가 fetchDateRange에서 받아온 리스트에 포함되어있는지 아닌지를 판단하는 함수
    func hasCourse(selectedDate: String) -> Bool {
        guard let selectedDate = selectedDate.toDate() else { return false }
        return dateCalendarList.map { $0.asDate() }.contains(selectedDate)
    }
    
    /// 선택한 날짜의 데이트 코스 정보를 불러오는 함수
    /// - Parameter selectedDate: 캘린더에서 내가 누른 날짜
    func fetchSelectedDateCourse(selectedDate: String) async throws {
        let data = try await HomeAPIService.fetchCourseList(selectedDate: selectedDate)
        guard let selectedDateCourse = try? JSONDecoder().decode(SelectedDateCourseDTO.self, from: data) else {
            print("선택한 날짜 데이트 코스 조회 Decoder오류")
            return
        }
        let placeList: [DatePath] = selectedDateCourse.places.map { placeElement in
            DatePath(title: placeElement.place.name, comment: placeElement.memo, distance: placeElement.distanceFromNext, location: .init(latitude: CLLocationDegrees(floatLiteral: placeElement.place.coordinate.latitude), longitude: CLLocationDegrees(floatLiteral: placeElement.place.coordinate.longitude)))
        }
        dateCourse = HomeCourse(courseTitle: selectedDateCourse.title, courseList: placeList)
    }
}

// MARK: - Coordinating
extension HomeViewModel {
    func startAddCourseFlow(type: AddCourseFlowType) {
        guard let coordinator = coordinator as? HomeCoordinator else { return }
        coordinator.startAddCourseFlow(type: type)
    }
}

extension HomeViewModel {
    func pushToAlarmView() {
        guard let coordinator = coordinator as? AlarmViewCoordinating else { return }
        coordinator.pushToAlarmViewController()
    }
}
