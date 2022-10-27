//
//  WaitingInvitationViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol WaitingInvitationCoordinatorLogic {

}

protocol WaitingInvitationBusinessLogic: BusinessLogic {

}

final class WaitingInvitationViewModel: BaseViewModel, WaitingInvitationBusinessLogic {
    let coordinator: WaitingInvitationCoordinatorLogic

    @Published var selectedPlanet: String
    @Published var planetName: String
    @Published var code: String

    init(
        selectedPlanet: String,
        planetName: String,
        code: String,
        coordinator: WaitingInvitationCoordinatorLogic
    ) {
        self.selectedPlanet = selectedPlanet
        self.planetName = planetName
        self.code = code
        self.coordinator = coordinator
    }
}
