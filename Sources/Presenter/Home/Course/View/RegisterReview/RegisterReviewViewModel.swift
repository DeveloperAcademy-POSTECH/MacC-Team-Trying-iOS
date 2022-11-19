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
    var coordinator: AddCourseFlowCoordinating
    private let addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl()
    
    var courseRequestDTO: CourseRequestDTO
    @Published var images: [UIImage]
    var reviewContent: String?
    
    init(
        coordinator: AddCourseFlowCoordinating,
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
        coordinator.popViewController()
    }
    
    func pushToNextView() {
        coordinator.pushToCompleteView(self.courseRequestDTO)
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
