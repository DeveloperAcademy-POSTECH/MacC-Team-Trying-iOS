//
//  CreatePlanetViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol CreatePlanetCoordinatorLogic {
    func coordinateToCreatePlanetCompleteScene(selectedPlanet: String, planetName: String, code: String)
    func coordinateToInvitationCodeScene()
}

protocol CreatePlanetBusinessLogic: BusinessLogic {
    func planetTextDidChanged(_ name: String)
    func nextButtonDidTapped()
    func alreadyHaveInvitationButtonDidTapped()
}

final class CreatePlanetViewModel: BaseViewModel, CreatePlanetBusinessLogic {

    let coordinator: CreatePlanetCoordinatorLogic

    private let planetService = PlanetService()

    @Published var planetName: String
    var selectedPlanet: String

    let planets: [String] = ["planet_purple", "planet_red", "planet_yellow", "planet_green"]

    init(coordinator: CreatePlanetCoordinatorLogic) {
        self.planetName = ""
        selectedPlanet = planets[0]
        self.coordinator = coordinator
    }

    func planetTextDidChanged(_ name: String) {
        if name.count < 16 {
            self.planetName = name
        } else {
            self.planetName = planetName
        }
    }

    func nextButtonDidTapped() {
        Task {
            do {
                let planetInfo = try await planetService.createPlanet(.init(name: planetName, image: selectedPlanet))

                DispatchQueue.main.async {
                    self.coordinator.coordinateToCreatePlanetCompleteScene(
                        selectedPlanet: self.selectedPlanet,
                        planetName: self.planetName,
                        code: planetInfo.code
                    )
                }
            }
        }

    }

    func updateSelectedPlanet(index: Int) {
        self.selectedPlanet = planets[index]
    }

    func alreadyHaveInvitationButtonDidTapped() {
        coordinator.coordinateToInvitationCodeScene()
    }
}
