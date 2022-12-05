//
//  EditReviewUseCase.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

protocol EditReviewUseCase {
    func editReview(reviewId: Int, content: String, images: [UIImage]) async throws
}

final class EditReviewUseCaseImpl: EditReviewUseCase {
    private let editReviewRepository: EditReviewRepository
    
    init(editReviewRepository: EditReviewRepository) {
        self.editReviewRepository = editReviewRepository
    }
    func editReview(reviewId: Int, content: String, images: [UIImage]) async throws {
        try await self.editReviewRepository.editReview(reviewId: reviewId, content: content, images: images)
    }
}
