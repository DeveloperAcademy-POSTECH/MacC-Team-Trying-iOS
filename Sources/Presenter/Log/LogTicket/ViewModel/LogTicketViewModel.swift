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

protocol DismissCoordinating {
    func dismissTicketViewController()
}

protocol LogFullImageCoordinating {
    func presentImageFullScreenViewController(
        imageUrl: [String],
        rootViewState: RootViewState,
        course: CourseEntity,
        selectedCourseIndex: Int,
        currentImageIndex: Int
    )
}

final class LogTicketViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    private var fetchReviewUseCase: FetchReviewUseCase
    
    private var tapCourseLikeUseCase: TapCourseLikeUseCase
    
    let selectedCourseIndex: Int
    
    @Published var course: CourseEntity
    
    @Published var reviews = [ReviewEntity]()
    
    init(
        coordinator: Coordinator,
        course: CourseEntity,
        selectedCourseIndex: Int,
        fetchReviewUseCase: FetchReviewUseCase = FetchReviewUseCaseImpl(),
        tapCourseLikeUseCase: TapCourseLikeUseCase = TapCourseLikeUseCaseImpl()
    ) {
        self.course = course
        self.selectedCourseIndex = selectedCourseIndex
        self.coordinator = coordinator
        self.fetchReviewUseCase = fetchReviewUseCase
        self.tapCourseLikeUseCase = tapCourseLikeUseCase
        super.init()
    }
    
    func tapDismissButton() {
        guard let coordinator = coordinator as? DismissCoordinating else { return }
        coordinator.dismissTicketViewController()
    }
    
    func presentImageFullScreenViewController(
        imageUrl: [String],
        rootViewState: RootViewState,
        currentImageIndex: Int
    ) {
        guard let coordinator = coordinator as? LogFullImageCoordinating else { return }
        coordinator.presentImageFullScreenViewController(
            imageUrl: imageUrl,
            rootViewState: rootViewState,
            course: course,
            selectedCourseIndex: selectedCourseIndex,
            currentImageIndex: currentImageIndex
        )
    }
}

extension LogTicketViewModel {
    func fetchReviews() async throws {
        reviews = try await
        fetchReviewUseCase.fetchReviewAsync(courseId: course.id)
    }
    
    func moveToHomeTab() {
        guard let coordinator = coordinator as? MoveFromLogToHome else { return }
        coordinator.goToHomeView(course: course)
    }
    
    func tapLikeCourse() async throws {
        try await tapCourseLikeUseCase.setCourseLike(courseId: course.id, isLike: course.isLike)
        course.isLike.toggle()
    }
}
