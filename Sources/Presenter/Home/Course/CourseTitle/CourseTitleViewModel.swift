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
    let coordinator: CourseFlowCoordinator
    
    var courseRequestDTO: CourseRequestDTO
    @Published var title: String {
        didSet {
            self.courseRequestDTO.title = self.title
        }
    }
    
    init(
        coordinator: CourseFlowCoordinator,
        courseRequestDTO: CourseRequestDTO
    ) {
        self.coordinator = coordinator
        self.courseRequestDTO = courseRequestDTO
        
        self.title = courseRequestDTO.title
    }
}

// MARK: - Coordinating
extension CourseTitleViewModel {
    func pop() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.popViewController()
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.popViewController()
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.popToHomeView()
            
        case is EditPlanCoordinator:
            guard let coordinator = self.coordinator as? EditPlanCoordinator else { return }
            coordinator.popToHomeView()
            
        default:
            break
        }
    }
    
    func pushToNextView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.pushToCourseMapView(courseRequestDTO)
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.pushToCourseMapView(courseRequestDTO)
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.pushToCourseMapView(courseRequestDTO)
            
        case is EditPlanCoordinator:
            guard let coordinator = self.coordinator as? EditPlanCoordinator else { return }
            coordinator.pushToCourseMapView(courseRequestDTO)
            
        default:
            break
        }
    }
}
