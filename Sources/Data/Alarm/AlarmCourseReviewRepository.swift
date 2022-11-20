//
//  AlarmCourseReviewRepository.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import CoreLocation

class AlarmCourseReviewRepository: AlarmCourseReviewInterface {
    
    var alarmIdAPI: AlarmIdAPI
    
    init(alarmIdAPI: AlarmIdAPI = AlarmIdAPI()) {
        self.alarmIdAPI = alarmIdAPI
    }
    
    func getCourseWith(id: String) async throws -> HomeCourse {
        let dto = try await alarmIdAPI.getCourseWith(.course, id: id)
        return .init(
            courseId: dto.courseID,
            courseDate: dto.date,
            courseTitle: dto.title,
            courseList: dto.places.map { course in
                .init(title: course.place.name, comment: course.memo, distance: course.distanceFromNext, location: .init(latitude: CLLocationDegrees(floatLiteral: course.place.coordinate.latitude), longitude: CLLocationDegrees(floatLiteral: course.place.coordinate.longitude)))
            }
        )
    }
    
    func getReviewWith(id: String) async throws -> AlarmReviewIdDTO {
        return try await alarmIdAPI.getReviewWith(.review, id: id)
    }
}
