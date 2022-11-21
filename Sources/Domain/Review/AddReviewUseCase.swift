//
//  AddReviewUseCase.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

protocol AddReviewUseCase {
    func addReview(courseId: Int, content: String, images: [UIImage]) async throws -> Int
}

final class AddReviewUseCaseImpl: AddReviewUseCase {
    private let addReviewRepository: AddReviewRepository
    
    init(addReviewRepository: AddReviewRepository) {
        self.addReviewRepository = addReviewRepository
    }
    
    func addReview(courseId: Int, content: String, images: [UIImage]) async throws -> Int {
        return try await self.addReviewRepository.addReview(courseId: courseId, content: content, images: images)
    }
}
