//
//  PlaceSearchViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/15.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit

final class PlaceSearchViewModel: BaseViewModel {
    var coordinator: Coordinator
    private let placeSearchUseCase: PlaceSearchUseCase
    
    @Published var name: String = ""
    
    @Published var places: [Place]
    
    init(
        coordinator: Coordinator,
        placeSearchUseCase: PlaceSearchUseCase = PlaceSearchUseCaseImpl(),
        places: [Place] = []
    ) {
        self.coordinator = coordinator
        self.placeSearchUseCase = placeSearchUseCase
        self.places = places
    }
}

// MARK: - Coordinating
extension PlaceSearchViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
}

// MARK: - Business Logic
extension PlaceSearchViewModel {
    func searchPlace() async throws {
        let coordinate = LocationManager.shared.getCurrentLocation()
        
        self.places = try await self.placeSearchUseCase.placeSearch(
            name: self.name,
            latitude: coordinate.latitude,
            longitude: coordinate.longitude
        )
    }
    
    func getPlace(index: Int) -> Place {
        return places[index]
    }
}
