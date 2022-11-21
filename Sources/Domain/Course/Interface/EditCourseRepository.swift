//
//  EditCourseRepository.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol EditCourseRepository {
    func editCourse(_ editCourseDTO: CourseRequestDTO) async throws -> Int
}
