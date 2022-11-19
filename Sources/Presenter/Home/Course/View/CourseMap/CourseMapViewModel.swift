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
    var coordinator: AddCourseFlowCoordinating
    
    private let addCourseUseCase: AddCourseUseCase
    
    var courseRequestDTO: CourseRequestDTO
    @Published var places: [Place]
    // @Published var memo: String?
    
    init(
        coordinator: AddCourseFlowCoordinating,
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
        coordinator.popViewController()
    }
    
    func pushToPlaceSearchView() {
        coordinator.pushToPlaceSearchView()
    }
    
    func pushToNextView() {
        coordinator.pushToRegisterReviewView(self.courseRequestDTO)
    }

    /*
    func pushToCourseCompleteView() {
        coordinator.pushToCompleteView(self.courseRequestDTO)
    }
     */
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
