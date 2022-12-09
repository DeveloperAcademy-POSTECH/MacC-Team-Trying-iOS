//
//  RegisterReviewViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

final class RegisterReviewViewModel: BaseViewModel {
    var coordinator: RegisterReviewCoordinator
    private let addCourseUseCase: AddCourseUseCase
    private let addReviewUseCase: AddReviewUseCase
    private let deleteCourseUseCase: DeleteCourseUseCase
    
    var courseRequestDTO: CourseRequestDTO
    @Published var images: [UIImage]
    @Published var reviewContent: String?
    @Published var isLoading: Bool = false
    
    init(
        coordinator: RegisterReviewCoordinator,
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl(addCourseRepository: AddCourseRepositoryImpl()),
        addReviewUseCase: AddReviewUseCase = AddReviewUseCaseImpl(addReviewRepository: AddReviewRepositoryImpl()),
        deleteCourseUseCase: DeleteCourseUseCase = DeleteCourseUseCaseImpl(deleteCourseRepository: DeleteCourseRepositoryImpl()),
        courseRequestDTO: CourseRequestDTO,
        images: [UIImage] = [],
        reviewContent: String? = nil
    ) {
        self.coordinator = coordinator
        self.addCourseUseCase = addCourseUseCase
        self.addReviewUseCase = addReviewUseCase
        self.deleteCourseUseCase = deleteCourseUseCase
        self.courseRequestDTO = courseRequestDTO
        self.images = images
        self.reviewContent = reviewContent
    }
}

// MARK: - Coordinating
extension RegisterReviewViewModel {
    func pop() {
        coordinator.popViewController()
    }
    
    func pushToNextView() {
        Task {
            guard let courseId = self.courseRequestDTO.id,
                  let reviewContent = reviewContent else { return }
            do {
                self.isLoading = true
                _ = try await self.addReviewUseCase.addReview(courseId: courseId, content: reviewContent, images: self.images)
                self.isLoading = false
                
                DispatchQueue.main.async {
                    self.coordinator.pushToCompleteView(self.courseRequestDTO)
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

// MARK: - Business Logic
extension RegisterReviewViewModel {
    func addImage(_ image: UIImage) {
        images.append(image)
    }
    
    func deleteImage(_ index: Int) {
        images.remove(at: index)
    }
    
    func swapImage(sourceIndex: Int, destinationIndex: Int) {
        let sourceImage = images.remove(at: sourceIndex)
        images.insert(sourceImage, at: destinationIndex)
    }
    
    func deleteCourse() {
        Task {
            do {
                self.isLoading = true
                try await self.deleteCourseUseCase.deleteCourse(courseRequestDTO.id!)
                self.isLoading = false
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}
