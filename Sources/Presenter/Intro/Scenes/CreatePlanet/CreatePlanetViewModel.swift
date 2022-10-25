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

    @Published var planetTextFieldState: TextFieldState
    @Published var planetName: String
    var selectedPlanet: String

    let planets: [String] = ["planet_purple", "planet_red", "planet_yellow", "planet_green"]

    init(coordinator: CreatePlanetCoordinatorLogic) {
        self.planetTextFieldState = .empty
        self.planetName = ""
        self.selectedPlanet = planets[0]
        self.coordinator = coordinator
    }

    func planetTextDidChanged(_ name: String) {
        if name.count < 9 {
            self.planetName = name
        } else {
            self.planetName = planetName
        }

        let nicknamePattern = #"^[가-힣A-Za-z0-9].{1,8}"#
        let result = planetName.range(of: nicknamePattern, options: .regularExpression)
        self.planetTextFieldState = result != nil ? .good : .invalidNickname
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
