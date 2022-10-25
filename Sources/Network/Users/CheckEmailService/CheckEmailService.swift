//
//  CheckEmailService.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct CheckEmailService {
    private let provider = NetworkProviderImpl<CheckEmailAPI>()

    func checkEmail(_ query: CheckEmailRequestModel) async throws -> CheckEmailResponseModel {
        try await provider.send(.validationEmail(query))
    }
}
