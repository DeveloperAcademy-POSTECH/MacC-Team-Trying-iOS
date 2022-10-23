//
//  EnterEmailViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EnterEmailCoordinatorLogic {
    func coordinateToEnterPasswordScene()
}

protocol EnterEmailBusinessLogic: BusinessLogic {
    func enterEmailButtonDidTapped()
}

final class EnterEmailViewModel: BaseViewModel, EnterEmailBusinessLogic {
    let coordinator: EnterEmailCoordinatorLogic

    init(coordinator: EnterEmailCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func enterEmailButtonDidTapped() {
        coordinator.coordinateToEnterPasswordScene()
    }
}
