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
    var coordinator: AddCourseFlowCoordinating
    
    @Published var memo: String?
    
    init(coordinator: AddCourseFlowCoordinating) {
        self.coordinator = coordinator
    }
}

// MARK: - Coordinating
extension PlaceSearchResultMapViewModel {
    func pop() {
        coordinator.popViewController()
    }
    
    func dismiss() {
        coordinator.dismissToPlaceSearchMapView()
    }
}
