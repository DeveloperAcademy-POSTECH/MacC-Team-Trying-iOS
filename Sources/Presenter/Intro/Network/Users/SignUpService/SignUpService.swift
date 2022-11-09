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

    func signup(_ body: SignUpRequestModel.Email) async throws -> SignUpResponseModel {
        try await provider.send(.signUp(body))
    }

    func signupWitHKakao(_ body: SignUpRequestModel.Kakao) async throws -> SignUpResponseModel {
        try await provider.send(.kakao(body))
    }

    func signupWithApple(_ body: SignUpRequestModel.Apple) async throws -> SignUpResponseModel {
        try await provider.send(.apple(body))
    }
}
