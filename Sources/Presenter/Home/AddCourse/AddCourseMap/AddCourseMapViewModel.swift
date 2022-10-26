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
    func pushToRegisterCourseViewController(places: [Place])
}

final class AddCourseMapViewModel: BaseViewModel {
    var coordinator: Coordinator
    @Published var places: [Place]
    var annotations: [MKAnnotation]
    
    init(coordinator: Coordinator, places: [Place] = [], annotations: [MKAnnotation] = []) {
        self.coordinator = coordinator
        self.places = places
        self.annotations = annotations
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
        coordinator.pushToRegisterCourseViewController(places: places)
    }
}

// MARK: - Methods
extension AddCourseMapViewModel {
    func addPlace(_ place: CLPlacemark) {
        places.append(convertToPlace(place: place))
    }
    
    func deletePlace(_ index: Int) {
        places.remove(at: index)
    }
    
    func addAnnotation(_ annotation: MKAnnotation) {
        annotations.append(annotation)
    }
    
    func deleteAnnotation(map: MKMapView, at index: Int) {
        map.removeAnnotation(annotations[index])
        annotations.remove(at: index)
    }
}

// MARK: - Helper
extension AddCourseMapViewModel {
    private func convertToPlace(place: CLPlacemark) -> Place {
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
            )
        )
    }
}
