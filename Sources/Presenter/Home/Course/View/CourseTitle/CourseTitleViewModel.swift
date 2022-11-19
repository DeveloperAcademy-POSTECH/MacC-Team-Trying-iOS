//
//  CourseTitleViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/05.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

final class CourseTitleViewModel: BaseViewModel {
    let coordinator: AddCourseFlowCoordinating
    
    var courseRequestDTO: CourseRequestDTO
    
    init(
        coordinator: AddCourseFlowCoordinating,
        courseRequestDTO: CourseRequestDTO
    ) {
        self.coordinator = coordinator
        self.courseRequestDTO = courseRequestDTO
    }
}

// MARK: - Coordinating
extension CourseTitleViewModel {
    func pop() {
        coordinator.popViewController()
    }
    
    func pushToNextView() {
        coordinator.pushToCourseMapView(courseRequestDTO)
    }
}
