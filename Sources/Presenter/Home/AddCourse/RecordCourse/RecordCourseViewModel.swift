//
//  RecordCourseViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/17.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import UIKit

protocol AddCourseCompleteCoordinating {
    func pushToAddCourseCompleteViewController(
        courseTitle: String,
        courseContent: String,
        places: [Place],
        images: [UIImage],
        isPublic: Bool
    )
}

final class RecordCourseViewModel: BaseViewModel {
    private let addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl()
    var coordinator: Coordinator
    
    let courseTitle: String
    let places: [Place]
    @Published var images: [UIImage]
    var courseContent: String?
    var isPublic: Bool
    
    init(
        coordinator: Coordinator,
        courseTitle: String,
        places: [Place],
        images: [UIImage] = [],
        isPublic: Bool = true
    ) {
        self.coordinator = coordinator
        self.courseTitle = courseTitle
        self.places = places
        self.images = images
        self.isPublic = isPublic
    }
}

// MARK: - Coordinating
extension RecordCourseViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushToAddCourseCompleteView() {
        guard let coordinator = coordinator as? AddCourseCompleteCoordinating else { return }
        coordinator.pushToAddCourseCompleteViewController(
            courseTitle: courseTitle,
            courseContent: courseContent ?? "",
            places: places,
            images: images,
            isPublic: isPublic
        )
    }
}

// MARK: - Business Logic
extension RecordCourseViewModel {
    func addImage(_ image: UIImage) {
        images.append(image)
    }
    
    func deleteImage(_ index: Int) {
        images.remove(at: index)
    }
}

// MARK: - API
extension RecordCourseViewModel {
    // TODO: api call
    // FIXME: Planet ID 수정하기
    func addCourseRecord() async throws {
        let dto = self.convertToDTO(
            planetId: "27",
            courseTitle: courseTitle,
            courseContent: courseContent ?? "",
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
