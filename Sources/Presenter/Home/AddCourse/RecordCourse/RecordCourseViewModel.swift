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
