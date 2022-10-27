//
//  AddCourseCompleteViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

protocol HomeCoordinating {
    func popToHomeViewController()
}

final class AddCourseCompleteViewModel: BaseViewModel {
    var coordinator: Coordinator
    private let courseTitle: String
    private let courseContent: String
    private let isPublic: Bool
    private let places: [Place]
    private let images: [UIImage]
    
    private let addCourseUseCase: AddCourseUseCase
    
    init(
        coordinator: Coordinator,
        courseTitle: String,
        courseContent: String,
        isPublic: Bool,
        places: [Place],
        images: [UIImage],
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl()
    ) {
        self.coordinator = coordinator
        self.courseTitle = courseTitle
        self.courseContent = courseContent
        self.isPublic = isPublic
        self.places = places
        self.images = images
        self.addCourseUseCase = addCourseUseCase
    }
}

// MARK: - Coordinating
extension AddCourseCompleteViewModel {
    func popToHomeView() {
        guard let coordinator = coordinator as? HomeCoordinating else { return }
        coordinator.popToHomeViewController()
    }
}

// MARK: - API
extension AddCourseCompleteViewModel {
    // TODO: api call
    // FIXME: Planet ID 수정하기
    func addCourse() async throws {
        let dto = self.convertToDTO(
            planetId: "27",
            courseTitle: courseTitle,
            courseContent: courseContent,
            isPublic: isPublic,
            places: places
        )
        try await addCourseUseCase.addCourse(addCourseDTO: dto, images: images)
    }
    
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
