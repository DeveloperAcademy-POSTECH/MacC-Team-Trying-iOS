//
//  FetchConstellationsUseCase.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol FetchConstellationsUseCase {
    func fetchLogAsyc() async throws -> [TestCourse]
}

// MARK: UseCase 구현체 부분입니다.
final class FetchConstellationsUseCaseImpl: FetchConstellationsUseCase {
    
    private let fetchConstellationRepository: FetchConstellationRepository
    
    init(fetchConstellationRepository: FetchConstellationRepository = FetchConstellationRepositoryImpl()) {
        self.fetchConstellationRepository = fetchConstellationRepository
    }
    
    func fetchLogAsyc() async throws -> [TestCourse] {
        try await fetchConstellationRepository.fetchLogAsyc()
    }
}
