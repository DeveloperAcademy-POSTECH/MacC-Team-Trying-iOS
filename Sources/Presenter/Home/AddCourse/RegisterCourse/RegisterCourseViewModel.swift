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
    func pushToAddCourseCompleteViewController(places: [Place])
}

final class RegisterCourseViewModel: BaseViewModel {
    var coordinator: Coordinator
    var places: [Place]
    @Published var images: [UIImage]
    
    init(
        coordinator: Coordinator,
        places: [Place],
        images: [UIImage] = []
    ) {
        self.coordinator = coordinator
        self.places = places
        self.images = images
    }
}

// MARK: - Coordinating
extension RegisterCourseViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    func pushToAddCourseCompleteView() {
        guard let coordinator = coordinator as? AddCourseCompleteCoordinating else { return }
        coordinator.pushToAddCourseCompleteViewController(places: places)
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
