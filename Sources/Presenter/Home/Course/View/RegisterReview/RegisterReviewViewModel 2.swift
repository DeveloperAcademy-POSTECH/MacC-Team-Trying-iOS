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
    var coordinator: CourseFlowCoordinator
    private let addCourseUseCase: AddCourseUseCase
    private let addReviewUseCase: AddReviewUseCase
    private let deleteCourseUseCase: DeleteCourseUseCase
    
    var courseRequestDTO: CourseRequestDTO
    @Published var images: [UIImage]
    @Published var reviewContent: String?
    @Published var isLoading: Bool = false
    
    init(
        coordinator: CourseFlowCoordinator,
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl(addCourseRepository: AddCourseRepositoryImpl()),
        addReviewUseCase: AddReviewUseCase = AddReviewUseCaseImpl(addReviewRepository: AddReviewRepositoryImpl()),
        deleteCourseUseCase: DeleteCourseUseCase = DeleteCourseUseCaseImpl(deleteCourseRepository: DeleteCourseRepositoryImpl()),
        courseRequestDTO: CourseRequestDTO,
        images: [UIImage] = []
    ) {
        self.coordinator = coordinator
        self.addCourseUseCase = addCourseUseCase
        self.addReviewUseCase = addReviewUseCase
        self.deleteCourseUseCase = deleteCourseUseCase
        self.courseRequestDTO = courseRequestDTO
        self.images = images
    }
}

// MARK: - Coordinating
extension RegisterReviewViewModel {
    func pop() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.popViewController()
            
        case is RegisterReviewCoordinator:
            guard let coordinator = self.coordinator as? RegisterReviewCoordinator else { return }
            coordinator.popViewController()
            
        default:
            break
        }
    }
    
    func pushToNextView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            Task {
                guard let courseId = self.courseRequestDTO.id,
                      let reviewContent = reviewContent else { return }
                do {
                    self.isLoading = true
                    _ = try await self.addReviewUseCase.addReview(courseId: courseId, content: reviewContent, images: self.images)
                    self.isLoading = false
                    
                    DispatchQueue.main.async {
                        coordinator.pushToCompleteView(self.courseRequestDTO)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        case is RegisterReviewCoordinator:
            guard let coordinator = self.coordinator as? RegisterReviewCoordinator else { return }
            Task {
                guard let courseId = self.courseRequestDTO.id,
                      let reviewContent = reviewContent else { return }
                do {
                    self.isLoading = true
                    _ = try await self.addReviewUseCase.addReview(courseId: courseId, content: reviewContent, images: self.images)
                    self.isLoading = false
                    
                    DispatchQueue.main.async {
                        coordinator.pushToCompleteView(self.courseRequestDTO)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        default:
            break
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
