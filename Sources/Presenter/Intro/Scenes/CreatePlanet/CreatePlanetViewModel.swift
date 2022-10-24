//
//  CreatePlanetViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol CreatePlanetCoordinatorLogic {}

protocol CreatePlanetBusinessLogic: BusinessLogic {
    func planetTextDidChanged(_ name: String)
}

final class CreatePlanetViewModel: BaseViewModel, CreatePlanetBusinessLogic {
    let coordinator: CreatePlanetCoordinatorLogic

    let planets: [String] = ["planet_purple", "planet_red", "planet_yellow", "planet_green"]

    @Published var planetName: String

    init(coordinator: CreatePlanetCoordinatorLogic) {
        self.planetName = ""
        self.coordinator = coordinator
    }

    func planetTextDidChanged(_ name: String) {
        if name.count < 16 {
            self.planetName = name
        } else {
            self.planetName = planetName
        }
    }
}
