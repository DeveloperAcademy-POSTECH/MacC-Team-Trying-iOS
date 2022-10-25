//
//  AddCourseMapViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit

import CancelBag

protocol Popable {
    func popViewController()
}

protocol PlaceSearchCoordinating {
    func pushToPlaceSearchViewController()
}

protocol RegisterCourseCoordinating {
    func pushToRegisterCourseViewController()
}

final class AddCourseMapViewModel: BaseViewModel {
    var coordinator: Coordinator
    @Published var places: [Place]
    
    init(coordinator: Coordinator, places: [Place] = []) {
        self.coordinator = coordinator
        self.places = places
    }
}

// MARK: - Coordinating
extension AddCourseMapViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushToPlaceSearchView() {
        guard let coordinator = coordinator as? PlaceSearchCoordinating else { return }
        coordinator.pushToPlaceSearchViewController()
    }
    
    func pushToRegisterCourseView() {
        guard let coordinator = coordinator as? RegisterCourseCoordinating else { return }
        coordinator.pushToRegisterCourseViewController()
    }
}

// MARK: - Methods
extension AddCourseMapViewModel {
    func addPlace(_ place: CLPlacemark, annotation: MKAnnotation) {
        places.append(convertToPlace(place: place, annotation: annotation))
    }
    
    func deletePlace(_ index: Int) {
        places.remove(at: index)
    }
}

// MARK: - Helper
extension AddCourseMapViewModel {
    private func convertToPlace(place: CLPlacemark, annotation: MKAnnotation) -> Place {
        let title = place.name ?? ""
        // TODO: 카테고리로 변경하기
        let category = place.country ?? ""
        let administrativeArea = place.administrativeArea ?? ""
        let locality = place.locality ?? ""
        let thoroughfare = place.thoroughfare ?? ""
        let subThoroughfare = place.subThoroughfare ?? ""
        let address = "\(administrativeArea) \(locality) \(thoroughfare) \(subThoroughfare)"
        
        return Place(
            title: title,
            category: category,
            address: address,
            location: CLLocationCoordinate2D(
                latitude: place.location?.coordinate.latitude ?? 0,
                longitude: place.location?.coordinate.longitude ?? 0
            ),
            annotation: annotation
        )
    }
}
