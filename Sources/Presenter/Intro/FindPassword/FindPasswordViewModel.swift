//
//  FindPasswordViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/18.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol FindPasswordCoordinatorLogic {
    func coordinateToConfirmPasswordScene()
}

protocol FindPasswordBusinessLogic: BusinessLogic {
    func sendEmailButtonDidTapped()
}

final class FindPasswordViewModel: BaseViewModel, FindPasswordBusinessLogic {
    let coordinator: FindPasswordCoordinatorLogic

    init(coordinator: FindPasswordCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func sendEmailButtonDidTapped() {
        coordinator.coordinateToConfirmPasswordScene()
    }
}
