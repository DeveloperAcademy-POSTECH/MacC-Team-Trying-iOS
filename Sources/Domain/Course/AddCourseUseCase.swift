//
//  AddCourseUseCase.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol AddCourseUseCase {
    func addCourse(courseRequestDTO: CourseRequestDTO) async throws -> Int
}

final class AddCourseUseCaseImpl: AddCourseUseCase {
    private let addCourseRepository: AddCourseRepository
    
    init(addCourseRepository: AddCourseRepository) {
        self.addCourseRepository = addCourseRepository
    }
    
    func addCourse(courseRequestDTO: CourseRequestDTO) async throws -> Int {
        try await addCourseRepository.addCourse(courseRequestDTO: courseRequestDTO)
    }
}
