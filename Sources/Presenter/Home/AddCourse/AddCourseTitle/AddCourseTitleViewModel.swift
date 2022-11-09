//
//  AddCourseTitleViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/05.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol AddCourseMapCoordinating {
    func pushToAddCourseMapViewController(courseTitle: String)
}

final class AddCourseTitleViewModel: BaseViewModel {
    let coordinator: Coordinator
    
    @Published var courseTitle: String = ""
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Coordinating
extension AddCourseTitleViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushToAddCourseMapView() {
        guard let coordinator = coordinator as? AddCourseMapCoordinating else { return }
        coordinator.pushToAddCourseMapViewController(courseTitle: courseTitle)
    }
}
