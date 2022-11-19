//
//  ProfileViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol ProfileCoordinatorLogic: Coordinator {
    func pushToEditDayView()
    func coordinateToEditProfile()
    func coordinateToEditPlanet(date: String, planetName: String, planetImageName: String)
}

final class ProfileViewModel: BaseViewModel {
    var coordinator: ProfileCoordinatorLogic
    private let userService: UserService

    // FIXME: Data binding
    @Published var numberOfPlaces: Int = 249
    @Published var planetImageName: String = "planet_purple"
    @Published var planetName: String = "찰리"

    var date: String

    init(
        coordinator: ProfileCoordinatorLogic,
        userService: UserService = UserService()
    ) {
        self.date = ""
        self.coordinator = coordinator
        self.userService = userService
    }

    func fetchUserInformation() {
        Task {
            do {
                let userInformation = try await userService.getUserInformations()
                planetImageName = userInformation.planet?.image ?? "planet_purple"
                planetName = userInformation.planet?.name ?? ""
                date = userInformation.planet?.meetDate ?? ""
            }
        }
    }

    func coordinateToEditPlanet() {
        coordinator.coordinateToEditPlanet(date: date, planetName: planetName, planetImageName: planetImageName)
    }
}

// MARK: - Coordinating
extension ProfileViewModel {
    func pushToEditDayView() {
        coordinator.pushToEditDayView()
    }

    func editProfileButtonDidTapped() {
        coordinator.coordinateToEditProfile()
    }
}
