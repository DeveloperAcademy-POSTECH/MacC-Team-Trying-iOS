//
//  LogMapViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit
import UIKit

import CancelBag

final class LogMapViewModel: BaseViewModel {
    private let coordinator: Coordinator
    
    var courses: [CourseEntity]
    var places: [PlaceEntity]
    
    init(
        coordinator: Coordinator,
        courses: [CourseEntity]
    ) {
        self.coordinator = coordinator
        self.courses = courses
        self.places = []
    }
}

// MARK: - Business Logic
extension LogMapViewModel {
    func fetchStarAnnotations(with courseId: Int) -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        
        guard let selectedCourse = self.courses.first(where: { $0.id == courseId }) else { return [] }
        
        self.places = selectedCourse.places
        selectedCourse.places.forEach { place in
            annotations.append(convertToStarAnnotation(place: place))
        }
        
        return annotations
    }
    
    func fetchConstellationAnnotations() -> [MKAnnotation] {
        var annotations = [MKAnnotation]()
        
        self.places.removeAll()
        self.courses.forEach { course in
            annotations.append(self.convertToConstellationAnnotation(course: course))
        }
        
        return annotations
    }
}

// MARK: - Helper
extension LogMapViewModel {
    private func convertToStarAnnotation(place: PlaceEntity) -> MKAnnotation {
        return StarAnnotation(coordinate: place.coordinate, placeId: place.id)
    }
    
    private func convertToConstellationAnnotation(course: CourseEntity) -> MKAnnotation {
        let places = course.places
        let averageLatitude = places.reduce(into: 0.0) { $0 += $1.coordinate.latitude } / Double(places.count)
        let averageLongitude = places.reduce(into: 0.0) { $0 += $1.coordinate.longitude } / Double(places.count)
        
        let annotation = ConstellationAnnotation(coordinate: CLLocationCoordinate2D(latitude: averageLatitude, longitude: averageLongitude), courseId: course.id)
        return annotation
    }
}
// MARK: - Coordinator
extension LogMapViewModel {
    func dismissButtonPressed() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
}
