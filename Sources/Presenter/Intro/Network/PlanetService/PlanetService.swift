//
//  PlanetService.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct PlanetService {
    private let provider = NetworkProviderImpl<PlanetAPI>()

    func createPlanet(_ body: PlanetRequestModel.CreatePlanet) async throws -> PlanetResponseModel.CreatePlanet {
        try await provider.send(.create(body))
    }

    func joinPlanet(_ body: PlanetRequestModel.JoinPlanet) async throws -> EmptyResponseBody {
        try await provider.send(.join(body))
    }

    func getInvitationCode(_ query: PlanetRequestModel.GetInvitationCode) async throws -> PlanetResponseModel.GetInvitationCode {
        try await provider.send(.getInvitationCode(query))
    }

    func getPlanetByCode(_ query: PlanetRequestModel.GetPlanetByCode) async throws -> PlanetResponseModel.GetPlanetByCode {
        try await provider.send(.getPlanetByCode(query))
    }
}
