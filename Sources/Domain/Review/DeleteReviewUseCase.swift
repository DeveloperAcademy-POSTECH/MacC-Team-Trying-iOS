//
//  DeleteReviewUseCase.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol DeleteReviewUseCase {
    func deleteReview(_ reviewId: Int) async throws
}

final class DeleteReviewUseCaseImpl: DeleteReviewUseCase {
    private let deleteReviewRepository: DeleteReviewRepository

    init(deleteReviewRepository: DeleteReviewRepository) {
        self.deleteReviewRepository = deleteReviewRepository
    }

    func deleteReview(_ reviewId: Int) async throws {
        try await self.deleteReviewRepository.deleteReview(reviewId)
    }
}
