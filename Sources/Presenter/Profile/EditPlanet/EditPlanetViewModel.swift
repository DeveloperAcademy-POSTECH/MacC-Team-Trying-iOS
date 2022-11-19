//
//  EditPlanetViewModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EditPlanetCoordinatorLogic {
    func back()
}

final class EditPlanetViewModel: BaseViewModel {

    let coordinator: EditPlanetCoordinatorLogic

    private let planetService = PlanetService()
    private let userService = UserService()
    
    @Published var planetTextFieldState: TextFieldState
    @Published var planetName: String = ""
    @Published var planetImage: String = ""

    var date: String

    init(
        date: String,
        planetName: String,
        planetImage: String,
        coordinator: EditPlanetCoordinatorLogic
    ) {
        self.date = date
        self.planetTextFieldState = .empty
        self.planetName = planetName
        self.planetImage = planetImage
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
                _ = try await userService.editPlanet(date: date, planetName: planetName, planetImageName: planetImage)
                
                DispatchQueue.main.async {
                    self.coordinator.back()
                }
            }
        }
    }
}
