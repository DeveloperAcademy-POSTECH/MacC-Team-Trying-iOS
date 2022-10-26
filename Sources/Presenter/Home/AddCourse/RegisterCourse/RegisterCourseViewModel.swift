//
//  RegisterCourseViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

protocol AddCourseCompleteCoordinating {
    func pushToAddCourseCompleteViewController(places: [Place])
}

final class RegisterCourseViewModel: BaseViewModel {
    var coordinator: Coordinator
    var places: [Place]
    
    init(
        coordinator: Coordinator,
        places: [Place]
    ) {
        self.coordinator = coordinator
        self.places = places
    }
    
    // MARK: Mock
    var imageNames: [String] = [
        "MyPlanetImage",
        "LumiPlanet",
        "YouthPlanet",
        "MyPlanetImage",
        "YouthPlanet"
    ]
}

// MARK: - Coordinating
extension RegisterCourseViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushToAddCourseCompleteView() {
        guard let coordinator = coordinator as? AddCourseCompleteCoordinating else { return }
        coordinator.pushToAddCourseCompleteViewController(places: places)
    }
}
