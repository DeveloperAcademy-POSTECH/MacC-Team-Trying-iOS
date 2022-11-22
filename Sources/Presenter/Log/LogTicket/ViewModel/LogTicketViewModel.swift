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
    
    private var fetchConstellationUseCase: FetchConstellationsUseCase
    
    private var tapCourseLikeUseCase: TapCourseLikeUseCase
    
    @Published var courses: [CourseEntity]
    
    let currentIndex: Int
    
    @Published var reviews = [ReviewEntity]()
    
    init(
        coordinator: Coordinator,
        courses: [CourseEntity],
        currentIndex: Int,
        fetchReviewUseCase: FetchReviewUseCase = FetchReviewUseCaseImpl(),
        tapCourseLikeUseCase: TapCourseLikeUseCase = TapCourseLikeUseCaseImpl(),
        fetchConstellationUseCase: FetchConstellationsUseCase = FetchConstellationsUseCaseImpl()
    ) {
        self.currentIndex = currentIndex
        self.courses = courses
        self.coordinator = coordinator
        self.fetchReviewUseCase = fetchReviewUseCase
        self.tapCourseLikeUseCase = tapCourseLikeUseCase
        self.fetchConstellationUseCase = FetchConstellationsUseCaseImpl()
        super.init()
    }
    
    func tapDismissButton() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
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
        fetchReviewUseCase.fetchReviewAsync(courseId: courses[currentIndex].id)
    }
    
    func fetchConstellation() async throws {
        courses = try await fetchConstellationUseCase.fetchLogAsync()
    }
    
    func moveToHomeTab() {
        guard let coordinator = coordinator as? MoveFromLogToHome else { return }
        coordinator.goToHomeView(course: courses[currentIndex])
    }
    
    func tapLikeCourse() async throws {
        try await tapCourseLikeUseCase.setCourseLike(courseId: courses[currentIndex].id, isLike: courses[currentIndex].isLike)
        courses[currentIndex].isLike.toggle()
    }
}
