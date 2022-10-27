//
//  InvitationCodeViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol InvitationCodeCoordinatorLogic {
    func coordinateToFindPlanetScene(planetName: String, planetImageName: String, code: String)
}

protocol InvitationCodeBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class InvitationCodeViewModel: BaseViewModel, InvitationCodeBusinessLogic {
    let coordinator: InvitationCodeCoordinatorLogic

    private let planetService = PlanetService()

    @Published var textFieldState: TextFieldState
    @Published var isLoading: Bool
    var code: String

    init(coordinator: InvitationCodeCoordinatorLogic) {
        self.textFieldState = .empty
        self.code = ""
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        Task {
            do {
                isLoading = true
                let planetInfo = try await planetService.getPlanetByCode(.init(code: code))
                isLoading = false

                DispatchQueue.main.async {
                    self.coordinator.coordinateToFindPlanetScene(
                        planetName: planetInfo.name,
                        planetImageName: planetInfo.image,
                        code: self.code
                    )
                }
            } catch {

            }
        }
    }

    func textFieldDidChange(_ text: String) {
        self.code = text
        self.textFieldState = text.count >= 6 ? .good : .empty
    }
}
