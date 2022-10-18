//
//  EnterPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EnterPasswordCoordinatorLogic {
    func coordinateToHomeScene()
    func coordinateToFindPasswordScene()
}

protocol EnterPasswordBusinessLogic {
    func loginButtonDidTapped()
    func findPasswordButtonDidTapped()
}

final class EnterPasswordViewModel: BaseViewModel, EnterPasswordBusinessLogic {
    private let coordinator: EnterPasswordCoordinatorLogic

    init(coordinator: EnterPasswordCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func loginButtonDidTapped() {
        coordinator.coordinateToHomeScene()
    }

    func findPasswordButtonDidTapped() {
        coordinator.coordinateToFindPasswordScene()
    }
}
