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
    func coordinateToHomeScene()
}

protocol InvitationCodeBusinessLogic: BusinessLogic {
    func nextButtonDidTapped()
    func textFieldDidChange(_ text: String)
}

final class InvitationCodeViewModel: BaseViewModel, InvitationCodeBusinessLogic {
    let coordinator: InvitationCodeCoordinatorLogic

    private let planetService = PlanetService()

    enum Stage {
        case notFound
        case found
    }

    @Published var textFieldState: TextFieldState
    @Published var stage: Stage
    @Published var isLoading: Bool
    var planetImage: String
    var planetName: String
    var code: String

    init(coordinator: InvitationCodeCoordinatorLogic) {
        self.textFieldState = .empty
        self.stage = .notFound
        self.code = ""
        self.planetImage = ""
        self.planetName = ""
        self.isLoading = false
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        switch stage {
        case .notFound:

            Task {
                do {
                    isLoading = true
                    let planetInfo = try await planetService.getPlanetByCode(.init(code: code))
                    isLoading = false
                    planetImage = planetInfo.image
                    planetName = planetInfo.name
                    stage = .found
                } catch {

                }
            }
        case .found:
            Task {
                do {
                    isLoading = true
                    _ = try await planetService.joinPlanet(.init(code: code))
                    isLoading = false

                    DispatchQueue.main.async {
                        self.coordinator.coordinateToHomeScene()
                    }
                } catch {
                    
                }
            }
        }
    }

    func textFieldDidChange(_ text: String) {
        self.code = text
    }
}
