//
//  CourseCompleteViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

final class CourseCompleteViewModel: BaseViewModel {
    var coordinator: AddCourseFlowCoordinating
    private let addCourseUseCase: AddCourseUseCase
    
    var courseRequestDTO: CourseRequestDTO
    
    init(
        coordinator: AddCourseFlowCoordinating,
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl(),
        courseRequestDTO: CourseRequestDTO
    ) {
        self.coordinator = coordinator
        self.addCourseUseCase = addCourseUseCase
        self.courseRequestDTO = courseRequestDTO
    }
}

// MARK: - Coordinating
extension CourseCompleteViewModel {
    func popToHomeView() {
        coordinator.popToHomeView()
    }
}
