//
//  SignInService.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct SignInService {
    private let provider = NetworkProviderImpl<SignInAPI>()

    func signIn(_ body: SignInRequestModel.Email) async throws -> SignInResponseModel {
        try await provider.send(.signIn(body))
    }

    func signInWithKakao(_ body: SignInRequestModel.Kakao) async throws -> SignInResponseModel {
        do {
            let responseModel: SignInResponseModel = try await provider.send(.kakao(body))
            return responseModel
        } catch {
            throw SignInError.nouser(body.identifier)
        }
    }

    func signInWithApple(_ body: SignInRequestModel.Apple) async throws -> SignInResponseModel {
        do {
            let responseModel: SignInResponseModel = try await provider.send(.apple(body))
            return responseModel
        } catch {
            throw SignInError.nouser(body.identifier)
        }

    }
}
