//
//  AlarmCourseReviewInterface.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol AlarmCourseReviewInterface {
    func getCourseWith(id: String) async throws -> AlarmCourseIdDTO
    func getReviewWith(id: String) async throws -> AlarmReviewIdDTO
}
