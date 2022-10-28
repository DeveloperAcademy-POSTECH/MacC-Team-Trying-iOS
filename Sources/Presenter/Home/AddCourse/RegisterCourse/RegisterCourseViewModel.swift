//
//  RegisterCourseViewModel.swift
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
        isPublic: Bool,
        places: [Place],
        images: [UIImage]
    )
}

final class RegisterCourseViewModel: BaseViewModel {
    var coordinator: Coordinator
    var places: [Place]
    
    @Published var images: [UIImage]
    var courseTitle: String?
    var courseContent: String?
    var isPublic: Bool
    
    init(
        coordinator: Coordinator,
        places: [Place],
        images: [UIImage] = [],
        isPublic: Bool = true
    ) {
        self.coordinator = coordinator
        self.places = places
        self.images = images
        self.isPublic = isPublic
    }
}

// MARK: - Coordinating
extension RegisterCourseViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushToAddCourseCompleteView(courseTitle: String, courseContent: String, isPublic: Bool) {
        guard let coordinator = coordinator as? AddCourseCompleteCoordinating else { return }
        coordinator.pushToAddCourseCompleteViewController(
            courseTitle: courseTitle,
            courseContent: courseContent,
            isPublic: isPublic,
            places: places,
            images: images
        )
    }
}

// MARK: - Business Logic
extension RegisterCourseViewModel {
    func addImage(_ image: UIImage) {
        images.append(image)
    }
    
    func deleteImage(_ index: Int) {
        images.remove(at: index)
    }
}
