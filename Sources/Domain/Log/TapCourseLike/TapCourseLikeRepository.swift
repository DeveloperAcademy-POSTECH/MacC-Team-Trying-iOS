//
//  TapCourseLikeRepository.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//
import Foundation

protocol TapCourseLikeRepository {
    func setCourseLike(courseId: Int, isLike: Bool) async throws
}
