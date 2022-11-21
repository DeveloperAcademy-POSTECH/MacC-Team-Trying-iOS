//
//  LogHomeViewModel.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation

import CancelBag

protocol TicketViewCoodinating {
    func presentTicketViewController(course: CourseEntity, currentIndex: Int)
}

protocol MyConstellationViewCoordinating {
    func pushMyConstellationViewController(courses: [CourseEntity])
}

protocol LogMapViewCoordinating {
    func pushLogMapViewController()
}

// MARK: ViewModel
final class LogHomeViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    private var fetchConstellationsUseCase: FetchConstellationsUseCase
    let alarmCourseReviewUseCase: AlarmCourseReviewUseCaseDelegate = AlarmCourseReviewUseCase(alarmCourseReviewInterface: AlarmCourseReviewRepository())
    
    @Published var courses = [CourseEntity]()
    
    init(coordinator: Coordinator, fetchConstellationUseCase: FetchConstellationsUseCase = FetchConstellationsUseCaseImpl()) {
        self.coordinator = coordinator
        self.fetchConstellationsUseCase = fetchConstellationUseCase
        super.init()
        Task {
            try await fetchConstellation()
        }
        setNotification()
    }
}

extension LogHomeViewModel {
    // 네이게이션 POP
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    // 별자리 콜렉션뷰 2X2로 전환
    func pushMyConstellationView(courses: [CourseEntity]) {
        guard let coordinator = coordinator as? MyConstellationViewCoordinating else { return }
        coordinator.pushMyConstellationViewController(courses: courses)
    }
    // 티켓뷰로 전환
    func presentTicketView(course: CourseEntity, currentIndex: Int) {
        guard let coordinator = coordinator as? TicketViewCoodinating else { return }
        coordinator.presentTicketViewController(course: course, currentIndex: currentIndex)
    }
    // 지도화면으로 전환
    func pushLogMapViewController() {
        guard let coordinator = coordinator as? LogMapViewCoordinating else { return }
        coordinator.pushLogMapViewController()
    }
}

// MARK: UseCase호출 Method
extension LogHomeViewModel {
    // MARK: 별자리 API UseCase 호출
    func fetchConstellation() async throws {
        courses = try await fetchConstellationsUseCase.fetchLogAsync()
    }
}

extension LogHomeViewModel {
    func setNotification() {
        NotificationCenter.default.addObserver(self, selector: #selector(getNotification), name: NSNotification.Name("REVIEW"), object: nil)
    }
    
    @objc
    private func getNotification(_ notification: Notification) {
        //MARK: DTO는 필요시 다른 모델에 매핑하여 사용
        guard let reviewId = notification.object as? String else { return }
        Task {
            let course = try await alarmCourseReviewUseCase.getCourseWith(id: reviewId)
            print("notification course:", course)
        }
    }
}
