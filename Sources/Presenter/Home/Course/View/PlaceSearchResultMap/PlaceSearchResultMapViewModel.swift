//
//  PlaceSearchResultMapViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

final class PlaceSearchResultMapViewModel: BaseViewModel {
    var coordinator: CourseFlowCoordinator
    
    @Published var memo: String?
    
    init(coordinator: CourseFlowCoordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Coordinating
extension PlaceSearchResultMapViewModel {
    func pop() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.popViewController()
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.popViewController()
            
        default:
            break
        }
    }
    
    func dismiss() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.dismissToPlaceSearchMapView()
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.dismissToPlaceSearchMapView()
            
        default:
            break
        }
    }
}
