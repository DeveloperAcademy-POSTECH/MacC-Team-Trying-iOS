//
//  ConfirmPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol ConfirmPasswordCoordinatorLogic {
    func backToConfirmPasswordScene()
}

protocol ConfirmPasswordBusinessLogic: BusinessLogic {
    func enterPasswordButtonDIdTapped()
}

final class ConfirmPasswordViewModel: BaseViewModel, ConfirmPasswordBusinessLogic {
    let coordinator: ConfirmPasswordCoordinatorLogic

    init(coordinator: ConfirmPasswordCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func enterPasswordButtonDIdTapped() {
        coordinator.backToConfirmPasswordScene()
    }
}
