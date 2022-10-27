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

    func signIn(_ body: SignInRequestModel) async throws -> SignInResponseModel {
        try await provider.send(.signIn(body))
    }
}
