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

protocol DisMissCoordinating {
    func dismissTicketViewController()
}

final class LogTicketViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    private var fetchReviewUseCase: FetchReviewUseCase
    
    var course: CourseEntity
    
    let currentIndex: Int
    
    @Published var reviews = [ReviewEntity]()
    
    init(
        coordinator: Coordinator,
        course: CourseEntity,
        currentIndex: Int,
        fetchReviewUseCase: FetchReviewUseCase = FetchReviewUseCaseImpl()
    ) {
        self.currentIndex = currentIndex
        self.course = course
        self.coordinator = coordinator
        self.fetchReviewUseCase = fetchReviewUseCase
        super.init()
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

extension LogTicketViewModel {
    // MARK: 리뷰 API UseCase 호출
    func fetchReviews() async throws {
        reviews = try await
        fetchReviewUseCase.fetchReviewAsync(courseId: course.id)
    }
    
    func moveToHomeTab() {
        guard let coordinator = coordinator as? MoveFromLogToHome else { return }
        coordinator.goToHomeView(course: course)
    }
}
