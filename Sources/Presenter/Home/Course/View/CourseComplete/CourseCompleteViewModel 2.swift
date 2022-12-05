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
    var coordinator: CourseFlowCoordinator
    
    var courseRequestDTO: CourseRequestDTO
    
    init(
        coordinator: CourseFlowCoordinator,
        courseRequestDTO: CourseRequestDTO
    ) {
        self.coordinator = coordinator
        self.courseRequestDTO = courseRequestDTO
    }
}

// MARK: - Coordinating
extension CourseCompleteViewModel {
    func popToHomeView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.popToHomeView()
            
        case is RegisterReviewCoordinator:
            guard let coordinator = self.coordinator as? RegisterReviewCoordinator else { return }
            coordinator.popToHomeView()
        
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.popToHomeView()
            
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
}
