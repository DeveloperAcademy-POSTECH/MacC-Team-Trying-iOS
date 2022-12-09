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
    var coordinator: RegisterReviewCoordinator
    
    var courseRequestDTO: CourseRequestDTO
    
    init(
        coordinator: RegisterReviewCoordinator,
        courseRequestDTO: CourseRequestDTO
    ) {
        self.coordinator = coordinator
        self.courseRequestDTO = courseRequestDTO
    }
}

// MARK: - Coordinating
extension CourseCompleteViewModel {
    func popToHomeView() {
        self.coordinator.popToHomeView()
    }
}
