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
    var coordinator: CourseFlowCoordinator
    private let placeSearchUseCase: PlaceSearchUseCase
    
    @Published var places: [Place]
    
    init(
        coordinator: CourseFlowCoordinator,
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
    
    func pushToPlaceSearchResultMapView(searchText: String, searchedPlaces: [Place], presentLocation: CLLocationCoordinate2D) {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.pushToPlaceSearchResultMapView(searchText: searchText, searchedPlaces: searchedPlaces, presentLocation: presentLocation)
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.pushToPlaceSearchResultMapView(searchText: searchText, searchedPlaces: searchedPlaces, presentLocation: presentLocation)
            
        default:
            break
        }
    }
}

// MARK: - Business Logic
extension PlaceSearchViewModel {
    func searchPlace(query: String) async throws {
        let locationManager = LocationManager.shared
        self.places = try await self.placeSearchUseCase.searchPlace(
            query: query,
            latitude: locationManager.latitude,
            longitude: locationManager.longitude
        )
    }
    
    func getPlace(index: Int) -> Place {
        return places[index]
    }
    
    func getPlaces() -> [Place] {
        return places
    }
}
