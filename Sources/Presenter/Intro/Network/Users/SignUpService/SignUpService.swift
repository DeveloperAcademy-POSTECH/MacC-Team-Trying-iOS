//
//  SignUpService.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct SignUpService {
    private let provider = NetworkProviderImpl<SignUpAPI>()

    func signup(_ body: SignUpRequestModel) async throws -> SignUpResponseModel {
        try await provider.send(.signUp(body))
    }
}
