//
//  EditProfileViewModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EditProfileCoordinatorLogic {
    func coordinateToEditNicknameScene(nickname: String)
    func coordinateToEditPasswordScene()
}

final class EditProfileViewModel: BaseViewModel {
    let coordinator: EditProfileCoordinatorLogic

    init(coordinator: EditProfileCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func coordinateToEditNicknameScene(nickname: String) {
        self.coordinator.coordinateToEditNicknameScene(nickname: nickname)
    }

    func passwordChangeButtonDidTapped() {
        self.coordinator.coordinateToEditPasswordScene()
    }
}
