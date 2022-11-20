//
//  DeleteCourseUseCase.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol DeleteCourseUseCase {
    func deleteCourse(_ courseId: Int) async throws
}

final class DeleteCourseUseCaseImpl: DeleteCourseUseCase {
    private let deleteCourseRepository: DeleteCourseRepository
    
    init(deleteCourseRepository: DeleteCourseRepository) {
        self.deleteCourseRepository = deleteCourseRepository
    }
    
    func deleteCourse(_ courseId: Int) async throws {
        return try await self.deleteCourseRepository.deleteCourse(courseId)
    }
}
