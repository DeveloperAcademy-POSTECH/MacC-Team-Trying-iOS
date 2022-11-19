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
    private let addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl()
    
    var courseRequestDTO: CourseRequestDTO
    @Published var images: [UIImage]
    var reviewContent: String?
    
    init(
        coordinator: CourseFlowCoordinator,
        courseRequestDTO: CourseRequestDTO,
        images: [UIImage] = []
    ) {
        self.coordinator = coordinator
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
            coordinator.pushToCompleteView(self.courseRequestDTO)
            
        case is RegisterReviewCoordinator:
            guard let coordinator = self.coordinator as? RegisterReviewCoordinator else { return }
            coordinator.pushToCompleteView(self.courseRequestDTO)
            
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
}
