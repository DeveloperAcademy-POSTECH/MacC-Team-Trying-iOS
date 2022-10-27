//
//  EmailVerificationService.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct EmailVerificationService {
    private let provider = NetworkProviderImpl<EmailVerificationAPI>()

    func checkEmail(_ body: EmailVerificationRequestModel.SendModel) async throws -> EmptyResponseBody {
        try await provider.send(.sendEmail(body))
    }

    func verificateCode(_ body: EmailVerificationRequestModel.VerificationModel) async throws -> EmptyResponseBody {
        try await provider.send(.verificationCode(body))
    }

    func resetPassword(_ body: EmailVerificationRequestModel.ResetPasswordModel) async throws -> EmptyResponseBody {
        try await provider.send(.resetPassword(body))
    }
}
