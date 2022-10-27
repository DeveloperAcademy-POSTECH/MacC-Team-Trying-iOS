//
//  FindPlanetViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/26.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol FindPlanetCoordinatorLogic {
    func coordinateToMainScene()
}

protocol FindPlanetBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
}

final class FindPlanetViewModel: BaseViewModel, FindPlanetBusinessLogic {
    let coordinator: FindPlanetCoordinatorLogic

    private let planetService = PlanetService()

    @Published var isLoading: Bool
    @Published var planetImage: String
    @Published var planetName: String
    @Published var code: String

    init(
        planetImage: String,
        planetName: String,
        code: String,
        coordinator: FindPlanetCoordinatorLogic
    ) {
        self.planetImage = planetImage
        self.planetName = planetName
        self.code = code
        self.coordinator = coordinator
        self.isLoading = false
    }

    func nextButtonDidTapped() {
        Task {
            do {
                isLoading = true
                _ = try await planetService.joinPlanet(.init(code: code))
                isLoading = false

                DispatchQueue.main.async {
                    self.coordinator.coordinateToMainScene()
                }
            } catch {

            }
        }
    }
}
