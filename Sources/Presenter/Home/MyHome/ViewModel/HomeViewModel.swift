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
    let courseId: Int?
    let courseDate: String
    let courseTitle: String
    let courseList: [DatePath]
}

struct DatePath {
    let title: String
    let comment: String
    let distance: Double?
    let location: CLLocationCoordinate2D
}

protocol AlarmResponseDelegate {
    func fetchAlarm()
}

final class HomeViewModel: BaseViewModel {
    var coordinator: Coordinator
    private let deleteCourseUseCase: DeleteCourseUseCase

    @Published var user: UserInfoDTO?
    @Published var dateCalendarList: [YearMonthDayDate] = []
    @Published var dateCourse: HomeCourse?
    @Published var places: [Place] = []
    @Published var selectedDate: Date = YearMonthDayDate.today.asDate()
    @Published var hasReview: Bool = false
    
    let alarmCourseReviewUseCase: AlarmCourseReviewUseCaseDelegate = AlarmCourseReviewUseCase(alarmCourseReviewInterface: AlarmCourseReviewRepository())
    
    private let alarmAPI = AlarmAPI()
    var delegate: AlarmResponseDelegate?
    
    init(
        coordinator: Coordinator,
        deleteCourseUseCase: DeleteCourseUseCase = DeleteCourseUseCaseImpl(
            deleteCourseRepository: DeleteCourseRepositoryImpl()
        )
    ) {
        self.coordinator = coordinator
        self.deleteCourseUseCase = deleteCourseUseCase
        super.init()
        NotificationCenter.default.addObserver(self, selector: #selector(getAllNotification), name: NSNotification.Name("NewAlarmHomeView"), object: nil)
        setNotification()
    }
    
    @objc
    func getAllNotification() {
        print("알람이 왔어용")
        self.delegate?.fetchAlarm()
    }
    
    func fetchUserInfo() async throws {
        let data = try await HomeAPIService.fetchUserAsync()
        guard let myUserInfo = try? JSONDecoder().decode(UserInfoDTO.self, from: data) else {
             print("Decoder오류")
             return
         }
        UserDefaults.standard.set(myUserInfo.me.name, forKey: "name")
        UserDefaults.standard.set(myUserInfo.planet?.image, forKey: "planetImageString")
        UserDefaults.standard.set(myUserInfo.mate?.name, forKey: "mateName")
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
    
    /// 선택한 날짜의 데이트 코스 정보를 불러오는 함수
    /// - Parameter selectedDate: 캘린더에서 내가 누른 날짜
    func fetchSelectedDateCourse(selectedDate: String) async throws {
        let data = try await HomeAPIService.fetchCourseList(selectedDate: selectedDate)
        guard let selectedDateCourse = try? JSONDecoder().decode(SelectedDateCourseDTO.self, from: data) else {
            print("선택한 날짜 데이트 코스 조회 Decoder오류")
            return
        }
        let placeList: [DatePath] = selectedDateCourse.places.map { placeElement in
            DatePath(title: placeElement.place.name, comment: placeElement.memo ?? " ", distance: placeElement.distanceFromNext, location: .init(latitude: CLLocationDegrees(floatLiteral: placeElement.place.coordinate.latitude), longitude: CLLocationDegrees(floatLiteral: placeElement.place.coordinate.longitude)))
        }
        places = selectedDateCourse.places.map { element in
            Place(id: element.place.placeId, title: element.place.name, category: element.place.category, address: element.place.address, location: .init(latitude: element.place.coordinate.latitude, longitude: element.place.coordinate.longitude), memo: element.memo)
        }
        dateCourse = HomeCourse(courseId: selectedDateCourse.courseId, courseDate: selectedDateCourse.date, courseTitle: selectedDateCourse.title, courseList: placeList)
        
        hasReview = selectedDateCourse.canReview
    }
    
    func deleteSelectedCourse() {
        Task {
            do {
                guard let courseId = self.dateCourse?.courseId else { return }
                try await self.deleteCourseUseCase.deleteCourse(courseId)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Coordinating
extension HomeViewModel {
    func startAddCourseFlow(type: CourseFlowType) {
        guard let coordinator = coordinator as? HomeCoordinator else { return }
        switch type {
        case .addCourse:
            coordinator.startAddCourseFlow(courseRequestDTO: .init(title: "", date: selectedDate.dateToString(), places: []))
        case .registerReview:
            guard let dateCourse = dateCourse else { return }
            coordinator.startRegisterReviewFlow(courseRequestDTO: .init(id: dateCourse.courseId, title: dateCourse.courseTitle, date: selectedDate.dateToString(), places: places))
        case .editCourse:
            guard let dateCourse = dateCourse else { return }
            coordinator.startEditCourseFlow(courseRequestDTO: .init(id: dateCourse.courseId, title: dateCourse.courseTitle, date: selectedDate.dateToString(), places: places))
        case .addPlan:
            coordinator.startAddPlanFlow(courseRequestDTO: .init(title: "", date: selectedDate.dateToString(), places: []))
        case .editPlan:
            guard let dateCourse = dateCourse else { return }
            coordinator.startEditPlanFlow(courseRequestDTO: .init(id: dateCourse.courseId, title: dateCourse.courseTitle, date: selectedDate.dateToString(), places: places))
        }
    }
}

extension HomeViewModel {
    func pushToAlarmView() {
        guard let coordinator = coordinator as? AlarmViewCoordinating else { return }
        coordinator.pushToAlarmViewController()
    }
}

extension HomeViewModel {
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification), name: NSNotification.Name("COURSE"), object: nil)
    }
    
    @objc
    private func getNotification(_ notification: Notification) {
        //MARK: DTO는 필요시 다른 모델에 매핑하여 사용
        guard let courseId = notification.object as? String else { return }
        Task {
            let course = try await alarmCourseReviewUseCase.getCourseWith(id: courseId)
            //MARK: 아래코드하면 달력뷰에서 그 날 날짜 코스나온다.
//            print("notification course:", course)
//            dateCourse = course
        }
  
    }
}

extension HomeViewModel {
    private func applyPermission() {
        alarmAPI.toggleAlarmPermission(type: .togglePermission, isPermission: UserDefaults().bool(forKey: "alarmPermission"))
    }
}
