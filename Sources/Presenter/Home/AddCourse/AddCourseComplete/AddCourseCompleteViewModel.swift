//
//  AddCourseCompleteViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

import Lottie

protocol HomeCoordinating {
    func popToHomeViewController()
}

final class AddCourseCompleteViewModel: BaseViewModel {
    var coordinator: Coordinator
    let courseTitle: String
    private let courseContent: String
    private let isPublic: Bool
    let places: [Place]
    private let images: [UIImage]
    
    private let addCourseUseCase: AddCourseUseCase
    
    init(
        coordinator: Coordinator,
        courseTitle: String,
        courseContent: String,
        isPublic: Bool,
        places: [Place],
        images: [UIImage],
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl()
    ) {
        self.coordinator = coordinator
        self.courseTitle = courseTitle
        self.courseContent = courseContent
        self.isPublic = isPublic
        self.places = places
        self.images = images
        self.addCourseUseCase = addCourseUseCase
    }
}

// MARK: - Coordinating
extension AddCourseCompleteViewModel {
    func popToHomeView() {
        guard let coordinator = coordinator as? HomeCoordinating else { return }
        coordinator.popToHomeViewController()
    }
}
