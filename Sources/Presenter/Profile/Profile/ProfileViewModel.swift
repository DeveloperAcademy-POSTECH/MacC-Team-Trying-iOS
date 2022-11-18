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
}

final class ProfileViewModel: BaseViewModel {
    var coordinator: ProfileCoordinatorLogic
    
    // FIXME: Data binding
    @Published var numberOfPlaces: Int = 249
    @Published var planetImageName: String = "planet_purple"
    @Published var planetName: String = "찰리"
    
    init(coordinator: ProfileCoordinatorLogic) {
        self.coordinator = coordinator
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
