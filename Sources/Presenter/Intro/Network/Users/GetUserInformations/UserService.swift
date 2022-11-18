//
//  UserService.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct UserService {
    private let provider = NetworkProviderImpl<UserAPI>()

    func getUserInformations() async throws -> UserResponseModel {
        return try await provider.send(.users)
    }
}
