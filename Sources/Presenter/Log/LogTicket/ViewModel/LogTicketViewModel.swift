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
import UIKit

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
    
    func presentEditReview() {
        guard let coordinator = coordinator as? LogCoordinator else { return }
        
        let dto = CourseRequestDTO(
            id: course.id,
            title: course.courseTitle,
            date: course.date,
            places: course.places.map { place in
                return Place(
                    id: place.id,
                    title: place.title,
                    category: place.category,
                    address: place.address,
                    location: place.coordinate,
                    memo: place.memo
                )
            }
        )
        coordinator.startEditReviewCoordinator(
            courseRequestDTO: dto,
            images: self.fetchImages(imageURLs: reviews[0].imagesURL),
            reviewContent: reviews[0].content
        )
    }
    
    private func fetchImages(imageURLs: [String]) -> [UIImage] {
        var images = [UIImage]()
        
        imageURLs.forEach { url in
            guard let url = URL(string: url) else { return }
//            let data = try? URLSession.shared.data(from: url)
            let data = try? Data(contentsOf: url)
             images.append(UIImage(data: data!)!)
        }
        
        return images
    }
}
