//
//  FetchConstellationsUseCase.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol FetchConstellationsUseCase {
    func fetchLogAsyc() async throws -> Data
}

final class FetchConstellationsUseCaseImpl: FetchConstellationsUseCase {
    
    private let fetchConstellationRepository: FetchConstellationRepository
    
    init(fetchConstellationRepository: FetchConstellationRepository = FetchConstellationRepositoryImpl()) {
        self.fetchConstellationRepository = fetchConstellationRepository
    }
    
    func fetchLogAsyc() async throws -> Data {
        try await fetchConstellationRepository.fetchLogAsyc()
    }
}
