//
//  AddCourseCompleteViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

protocol HomeCoordinating {
    func popToHomeViewController()
}

final class AddCourseCompleteViewModel: BaseViewModel {
    var coordinator: Coordinator
    private let courseTitle: String
    private let courseContent: String
    private let isPublic: Bool
    private let places: [Place]
    
    init(
        coordinator: Coordinator,
        courseTitle: String,
        courseContent: String,
        isPublic: Bool,
        places: [Place]
    ) {
        self.coordinator = coordinator
        self.courseTitle = courseTitle
        self.courseContent = courseContent
        self.isPublic = isPublic
        self.places = places
    }
}

// MARK: - Coordinating
extension AddCourseCompleteViewModel {
    func popToHomeView() {
        guard let coordinator = coordinator as? HomeCoordinating else { return }
        coordinator.popToHomeViewController()
    }
}
