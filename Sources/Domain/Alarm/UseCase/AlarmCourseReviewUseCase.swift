//
//  AlarmCourseReviewUseCase.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol AlarmCourseReviewUseCaseDelegate {
    func getCourseWith(id: String) async throws -> AlarmCourseIdDTO
    func getReviewWith(id: String) async throws -> AlarmReviewIdDTO
}

class AlarmCourseReviewUseCase: AlarmCourseReviewUseCaseDelegate {
    
    let alarmCourseReviewInterface: AlarmCourseReviewInterface
    
    init(alarmCourseReviewInterface: AlarmCourseReviewInterface) {
        self.alarmCourseReviewInterface = alarmCourseReviewInterface
    }
    
    func getCourseWith(id: String) async throws -> AlarmCourseIdDTO {
        return try await alarmCourseReviewInterface.getCourseWith(id: id)
    }
    
    func getReviewWith(id: String) async throws -> AlarmReviewIdDTO {
        return try await alarmCourseReviewInterface.getReviewWith(id: id)
    }
     
}
