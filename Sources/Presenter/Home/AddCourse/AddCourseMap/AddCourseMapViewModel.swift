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
    func pushToPlaceSearchViewController(delegate: PlacePresenting)
}

protocol RecordCourseCoordinating {
    func pushToRecordCourseViewController(courseTitle: String, places: [Place])
}

final class AddCourseMapViewModel: BaseViewModel {
    var coordinator: Coordinator
    private let addCourseUseCase: AddCourseUseCase
    private let placeSearchUseCase: PlaceSearchUseCase
    
    let courseTitle: String
    @Published var places: [Place]
    @Published var memo: String?
    var annotations: [MKAnnotation]
    
    init(
        coordinator: Coordinator,
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl(),
        placeSearchUseCase: PlaceSearchUseCase = PlaceSearchUseCaseImpl(),
        courseTitle: String,
        places: [Place] = [],
        annotations: [MKAnnotation] = []
    ) {
        self.coordinator = coordinator
        self.addCourseUseCase = addCourseUseCase
        self.placeSearchUseCase = placeSearchUseCase
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
    
    func pushToPlaceSearchView(delegate: PlacePresenting) {
        guard let coordinator = coordinator as? PlaceSearchCoordinating else { return }
        coordinator.pushToPlaceSearchViewController(delegate: delegate)
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
    func addPlace(_ place: Place) {
        var selectedPlace = place
        selectedPlace.memo = self.memo
        places.append(selectedPlace)
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
    
    func changePlaceOrder(sourceIndex: Int, to destinationIndex: Int) {
        let targetPlace = places[sourceIndex]
        places.remove(at: sourceIndex)
        places.insert(targetPlace, at: destinationIndex)
    }
}

// MARK: - API
extension AddCourseMapViewModel {
    func addCoursePlan() async throws {
        let dto = self.convertToDTO(
            planetId: "27",
            courseTitle: courseTitle,
            courseContent: "",
            isPublic: false,
            places: places
        )
        try await self.addCourseUseCase.addCourse(addCourseDTO: dto, images: [])
    }
    
    func searchPlace(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> Place? {
        let places = try await self.placeSearchUseCase.placeSearch(latitude: latitude, longitude: longitude)
        return places.first
    }
}

// MARK: - Helper
extension AddCourseMapViewModel {
    private func convertToDTO(
        planetId: String,
        courseTitle: String,
        courseContent: String,
        isPublic: Bool,
        places: [Place]
    ) -> AddCourseDTO {
        var tags: [AddCourseDTO.Tag] = []
        places.forEach { place in
            let place = AddCourseDTO.Place(name: place.title, latitude: place.location.latitude, longitude: place.location.longitude)
            // TODO: place 이름과 tag 이름 다르게 하기
            let tag = AddCourseDTO.Tag(place: place, name: place.name)
            tags.append(tag)
        }
        
        return AddCourseDTO(
            planetId: planetId,
            title: courseTitle,
            body: courseContent,
            access: isPublic ? "PUBLIC" : "PRIVATE",
            tags: tags
        )
    }
}
