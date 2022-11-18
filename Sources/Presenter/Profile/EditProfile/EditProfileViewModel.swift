//
//  EditProfileViewModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine

import CancelBag

protocol EditProfileCoordinatorLogic {
    func coordinateToEditNicknameScene(nickname: String)
    func coordinateToEditPasswordScene()
    func coordinateToLoginScene()
    func coordinateToDeRegisterScene()
}

final class EditProfileViewModel: BaseViewModel {
    let coordinator: EditProfileCoordinatorLogic
    private let userSerivce: UserService

    @Published var email: String
    @Published var nickname: String

    init(
        coordinator: EditProfileCoordinatorLogic,
        userService: UserService = UserService()
    ) {
        self.email = ""
        self.nickname = ""
        self.coordinator = coordinator
        self.userSerivce = userService
    }

    func coordinateToEditNicknameScene(nickname: String) {
        self.coordinator.coordinateToEditNicknameScene(nickname: nickname)
    }

    func passwordChangeButtonDidTapped() {
        self.coordinator.coordinateToEditPasswordScene()
    }

    func logout() {
        Task {
            do {
                _ = try await self.userSerivce.logout()
                DispatchQueue.main.async { [weak self] in
                    UserDefaults.standard.removeObject(forKey: "accessToken")
                    self?.coordinator.coordinateToLoginScene()
                }
            } catch {

            }
        }
    }

    func deregister() {
        coordinator.coordinateToDeRegisterScene()
    }
}
