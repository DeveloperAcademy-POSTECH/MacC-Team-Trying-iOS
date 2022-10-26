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
    @Published var places: [Place]
    
    init(coordinator: Coordinator, places: [Place] = []) {
        self.coordinator = coordinator
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
    /// 검색 결과를 가지고 MKLocalSearch를 수행합니다.
    /// - Parameter text: TextField에 입력된 String
    func searchPlace(_ text: String) {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = text
        let search = MKLocalSearch(request: request)
        
        var tempPlaces: [Place] = []
        search.start { [weak self] response, _ in
            guard let response = response, let self = self else { return }
            
            response.mapItems.forEach { [weak self] place in
                guard let self = self else { return }
                // MARK: 검색 지역을 대한민국으로 제한합니다.
                if place.placemark.countryCode == "KR" {
                    tempPlaces.append(self.convertToPlace(place))
                }
            }
            self.places = tempPlaces
        }
    }
    
    func addCourse(_ index: Int) {
        // TODO: 코스추가 눌렀을 때 annotation 추가하기
//        places[index]
        let selectedPlace = places[index]
    }
}

// MARK: - Helper
extension PlaceSearchViewModel {
    private func convertToPlace(_ place: MKMapItem) -> Place {
        let address = "\(place.placemark.administrativeArea ?? "") \(place.placemark.locality ?? "") \(place.placemark.thoroughfare ?? "") \(place.placemark.subThoroughfare ?? "")"
        
        return Place(
            title: place.name ?? "",
            category: place.pointOfInterestCategory?.koreanCategory ?? "",
            address: address,
            location: place.placemark.coordinate
        )
    }
}
