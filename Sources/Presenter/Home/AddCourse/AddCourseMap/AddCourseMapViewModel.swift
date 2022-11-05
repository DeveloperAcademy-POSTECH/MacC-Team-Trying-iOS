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

protocol RecordCourseCoordinating {
    func pushToRecordCourseViewController(courseTitle: String, places: [Place])
}

final class AddCourseMapViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    let courseTitle: String
    @Published var places: [Place]
    @Published var memo: String?
    var annotations: [MKAnnotation]
    
    init(
        coordinator: Coordinator,
        courseTitle: String,
        places: [Place] = [],
        annotations: [MKAnnotation] = []
    ) {
        self.coordinator = coordinator
        self.courseTitle = courseTitle
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
    
    func pushToRecordCourseView() {
        guard let coordinator = coordinator as? RecordCourseCoordinating else { return }
        coordinator.pushToRecordCourseViewController(
            courseTitle: courseTitle,
            places: places
        )
    }
    
    func pushToAddCourseCompleteView() {
        guard let coordinator = coordinator as? AddCourseCompleteCoordinating else { return }
        coordinator.pushToAddCourseCompleteViewController(
            courseTitle: courseTitle,
            courseContent: "",
            places: places,
            images: [],
            isPublic: false
        )
    }
}

// MARK: - Methods
extension AddCourseMapViewModel {
    func addPlace(_ place: CLPlacemark) {
        places.append(convertToPlace(place: place, memo: memo))
        self.memo = nil
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
    private func convertToPlace(place: CLPlacemark, memo: String?) -> Place {
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
            memo: memo
        )
    }
}
