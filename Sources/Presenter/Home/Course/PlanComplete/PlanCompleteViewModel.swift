//
//  PlanCompleteViewModel.swift
//  우주라이크
//
//  Created by 김승창 on 2022/12/09.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation
import UIKit

final class PlanCompleteViewModel: BaseViewModel {
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
extension PlanCompleteViewModel {
    func popToHomeView() {
        switch coordinator {
        case is EditCourseCoordinator:
            guard let coordinator = coordinator as? EditCourseCoordinator else { return }
            coordinator.popToHomeView()
            
        case is AddPlanCoordinator:
            guard let coordinator = coordinator as? AddPlanCoordinator else { return }
            coordinator.popToHomeView()
            
        default:
            break
        }
    }
}
