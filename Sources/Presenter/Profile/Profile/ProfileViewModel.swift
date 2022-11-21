//
//  ProfileViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation

import CancelBag

protocol ProfileCoordinatorLogic: Coordinator {
    func pushToEditDayView()
    func coordinateToEditProfile()
    func coordinateToEditPlanet(date: String, planetName: String, planetImageName: String)
    func coordinateToLoginScene()
    func pushToServiceTermView()
    func coordinateToExitPlanet(type: OutgoingType)
}

final class ProfileViewModel: BaseViewModel {
    var coordinator: ProfileCoordinatorLogic
    private let userService: UserService

    // @Published var numberOfPlaces: Int
    @Published var planetImageName: String
    @Published var planetName: String
    @Published var activities: (Int, Int)       // 내 별자리 개수, 좋아하는 코스 개수
    var date: String

    init(
        coordinator: ProfileCoordinatorLogic,
        userService: UserService = UserService()
    ) {
        // self.numberOfPlaces = 0
        self.planetImageName = ""
        self.planetName = ""
        self.activities = (0, 0)
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
                activities.0 = userInformation.activities?.courseCount ?? 10000
                activities.1 = userInformation.activities?.likedCount ?? 10000
                date = userInformation.planet?.meetDate ?? ""
            }
        }
    }
    
    func editDate() {
        Task {
            do {
                _ = try await self.userService.editPlanet(date: date, planetName: self.planetName, planetImageName: self.planetImageName)
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func coordinateToExitPlanet() {
        coordinator.coordinateToExitPlanet(type: .exitPlanet)
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
    
    func coordinateToEditPlanet() {
        coordinator.coordinateToEditPlanet(date: date, planetName: planetName, planetImageName: planetImageName)
    }
    
    func pushToServiceTermView() {
        self.coordinator.pushToServiceTermView()
    }
}

extension ProfileViewModel {
    func pushToEditNotificationView() {
        guard let coordinator = coordinator as? EditNotificationCoordinating else { return }
        coordinator.pushToEditNotificationView()
    }
}
