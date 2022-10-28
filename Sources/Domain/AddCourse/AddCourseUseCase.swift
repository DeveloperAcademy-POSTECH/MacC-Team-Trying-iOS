//
//  AddCourseUseCase.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol AddCourseRepository {
    func addCourse(addCourseDTO: AddCourseDTO, images: [UIImage]) async throws
}

protocol AddCourseUseCase {
    func addCourse(addCourseDTO: AddCourseDTO, images: [UIImage]) async throws
}

final class AddCourseUseCaseImpl: AddCourseUseCase {
    private let addCourseRepository: AddCourseRepository
    
    init(addCourseRepository: AddCourseRepository = AddCourseRepositoryImpl()) {
        self.addCourseRepository = addCourseRepository
    }
    
    func addCourse(addCourseDTO: AddCourseDTO, images: [UIImage]) async throws {
        try await addCourseRepository.addCourse(addCourseDTO: addCourseDTO, images: images)
    }
}
