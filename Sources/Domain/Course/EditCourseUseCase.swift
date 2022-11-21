//
//  EditCourseUseCase.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol EditCourseUseCase {
    func editCourse(editCourseDTO: CourseRequestDTO) async throws -> Int
}

final class EditCourseUseCaseImpl: EditCourseUseCase {
    private let editCourseRepository: EditCourseRepository
    
    init(editCourseRepository: EditCourseRepository) {
        self.editCourseRepository = editCourseRepository
    }
    
    func editCourse(editCourseDTO: CourseRequestDTO) async throws -> Int {
        return try await self.editCourseRepository.editCourse(editCourseDTO)
    }
}
