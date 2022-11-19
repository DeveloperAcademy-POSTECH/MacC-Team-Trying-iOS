//
//  WaitingInvitationViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol WaitingInvitationCoordinatorLogic {
    func coordinateToMainScene()
    func coordinateToCreatePlanetScene()
}

protocol WaitingInvitationBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func deletePlanet()
}

final class WaitingInvitationViewModel: BaseViewModel, WaitingInvitationBusinessLogic {
    let coordinator: WaitingInvitationCoordinatorLogic

    private let planetService: PlanetService

    @Published var selectedPlanet: String
    @Published var planetName: String
    @Published var code: String

    init(
        selectedPlanet: String,
        planetName: String,
        code: String,
        planetService: PlanetService = PlanetService(),
        coordinator: WaitingInvitationCoordinatorLogic
    ) {
        self.selectedPlanet = selectedPlanet
        self.planetName = planetName
        self.code = code
        self.planetService = planetService
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        coordinator.coordinateToMainScene()
    }

    func deletePlanet() {
        Task {
            do {
                _ = try await planetService.deletePlanet()
                DispatchQueue.main.async { [weak self] in
                    self?.coordinator.coordinateToCreatePlanetScene()
                }
            } catch {

            }
        }
    }
}
