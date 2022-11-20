//
//  AlarmCourseReviewRepository.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

class AlarmCourseReviewRepository: AlarmCourseReviewInterface {
    
    var alarmIdAPI: AlarmIdAPI
    
    init(alarmIdAPI: AlarmIdAPI = AlarmIdAPI()) {
        self.alarmIdAPI = alarmIdAPI
    }
    
    func getCourseWith(id: String) async throws -> AlarmCourseIdDTO {
        return try await alarmIdAPI.getCourseWith(.course, id: id)
    }
    
    func getReviewWith(id: String) async throws -> AlarmReviewIdDTO {
        return try await alarmIdAPI.getReviewWith(.review, id: id)
    }
}
