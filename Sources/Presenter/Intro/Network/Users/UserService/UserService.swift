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
        try await provider.send(.users)
    }

    func logout() async throws -> EmptyResponseBody {
        try await provider.send(.logout)
    }

    func deregister() async throws -> EmptyResponseBody {
        try await provider.send(.deregister)
    }

    func editNickname(nickname: String) async throws -> EmptyResponseBody {
        try await provider.send(.editNickname(.init(name: nickname)))
    }

    func editPassword(password: String, changePw: String) async throws -> EmptyResponseBody {
        try await provider.send(
            .editPassword(
                .init(
                    previousPassword: password,
                    updatePassword: changePw
                )
            )
        )
    }

    func editPlanet(date: String, planetName: String, planetImageName: String) async throws -> EmptyResponseBody {
        try await provider.send(.editPlanet(.init(name: planetName, date: date, image: planetImageName)))
    }
}
