//
//  CourseMapViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit

import CancelBag

final class CourseMapViewModel: BaseViewModel {
    var coordinator: CourseFlowCoordinator
    
    private let addCourseUseCase: AddCourseUseCase
    
    var courseRequestDTO: CourseRequestDTO
    @Published var places: [Place]
    // @Published var memo: String?
    
    init(
        coordinator: CourseFlowCoordinator,
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl(),
        courseRequestDTO: CourseRequestDTO,
        places: [Place] = []
    ) {
        self.coordinator = coordinator
        self.addCourseUseCase = addCourseUseCase
        self.courseRequestDTO = courseRequestDTO
        self.places = places
    }
}

// MARK: - Coordinating
extension CourseMapViewModel {
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
            coordinator.popViewController()
            
        default:
            break
        }
    }
    
    func pushToPlaceSearchView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        default:
            break
        }
    }
    
    func pushToNextView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.pushToRegisterReviewView(self.courseRequestDTO)
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.pushToCompleteView(self.courseRequestDTO)
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.pushToCompleteView(self.courseRequestDTO)
            
        default:
            break
        }
    }
}

// MARK: - Methods
extension CourseMapViewModel {
    func addPlace(_ place: Place) {
        /*
        var selectedPlace = place
        selectedPlace.memo = self.memo
        places.append(selectedPlace)
        self.memo = nil
         */
        self.places.append(place)
    }
    
    func deletePlace(_ index: Int) {
        places.remove(at: index)
    }
    
    func changePlaceOrder(sourceIndex: Int, to destinationIndex: Int) {
        let targetPlace = places[sourceIndex]
        places.remove(at: sourceIndex)
        places.insert(targetPlace, at: destinationIndex)
    }
}
