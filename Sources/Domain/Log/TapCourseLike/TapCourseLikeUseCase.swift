//  TapCourseLikeUseCase.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol TapCourseLikeUseCase {
    func setCourseLike(courseId: Int, isLike: Bool) async throws
}

final class TapCourseLikeUseCaseImpl: TapCourseLikeUseCase {

    private let tapCourseLikeRepository: TapCourseLikeRepository

    init(tapCourseLikeRepository: TapCourseLikeRepository = TapCourseLikeRepositoryImpl()) {
        self.tapCourseLikeRepository = tapCourseLikeRepository
    }

    func setCourseLike(courseId: Int, isLike: Bool) async throws {
        try await tapCourseLikeRepository.setCourseLike(courseId: courseId, isLike: isLike)
    }
}
