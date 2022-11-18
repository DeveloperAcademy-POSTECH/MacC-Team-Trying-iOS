//
//  PlaceSearchResultMapViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol PlaceSearchResultMapViewDismissable {
    func dismissToPlaceSearchMapView()
}

final class PlaceSearchResultMapViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    @Published var memo: String?
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Coordinating
extension PlaceSearchResultMapViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func dismiss() {
        guard let coordinator = coordinator as? PlaceSearchResultMapViewDismissable else { return }
        coordinator.dismissToPlaceSearchMapView()
    }
}
