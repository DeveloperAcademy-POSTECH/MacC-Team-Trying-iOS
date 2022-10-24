//
//  CreatePlanetCompleteViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol CreatePlanetCompleteCoordinatorLogic {}

protocol CreatePlanetCompleteBuisnessLogic: BusinessLogic {}

final class CreatePlanetCompleteViewModel: BaseViewModel, CreatePlanetCompleteBuisnessLogic {
    let coordinator: CreatePlanetCompleteCoordinatorLogic

    @Published var selectedPlanet: String
    @Published var planetName: String

    init(
        selectedPlanet: String,
        planetName: String,
        coordinator: CreatePlanetCompleteCoordinatorLogic
    ) {
        self.selectedPlanet = selectedPlanet
        self.planetName = planetName
        self.coordinator = coordinator
    }
}
