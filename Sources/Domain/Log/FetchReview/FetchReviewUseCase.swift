//
//  FetchReviewUseCase.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol FetchReviewUseCase {
    func fetchReviewAsync(courseId: Int) async throws -> [ReviewEntity]
    
}

// MARK: UseCase 구현체 부분입니다.
final class FetchReviewUseCaseImpl: FetchReviewUseCase {
    func fetchReviewAsync(courseId: Int) async throws -> [ReviewEntity] {
        try await fetchReviewRepository.fetchReviewAsync(courseId: courseId)
    }
    
    private let fetchReviewRepository: FetchReviewRepository
    
    init(fetchReviewRepository: FetchReviewRepository = FetchReviewRepositoryImpl()) {
        self.fetchReviewRepository = fetchReviewRepository
    }
    
}
