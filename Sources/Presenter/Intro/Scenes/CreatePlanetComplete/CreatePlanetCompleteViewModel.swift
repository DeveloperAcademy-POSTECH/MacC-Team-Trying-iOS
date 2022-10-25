//
//  CreatePlanetCompleteViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol CreatePlanetCompleteCoordinatorLogic {
    func coordinateToWaitingInvitationScene(selectedPlanet: String, planetName: String, code: String)
}

protocol CreatePlanetCompleteBuisnessLogic: BusinessLogic {
    func nextButtonDidTapped()
}

final class CreatePlanetCompleteViewModel: BaseViewModel, CreatePlanetCompleteBuisnessLogic {
    let coordinator: CreatePlanetCompleteCoordinatorLogic

    @Published var selectedPlanet: String
    @Published var planetName: String
    let code: String

    init(
        selectedPlanet: String,
        planetName: String,
        code: String,
        coordinator: CreatePlanetCompleteCoordinatorLogic
    ) {
        self.code = code
        self.selectedPlanet = selectedPlanet
        self.planetName = planetName
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        coordinator.coordinateToWaitingInvitationScene(selectedPlanet: selectedPlanet, planetName: planetName, code: code)
    }
}
