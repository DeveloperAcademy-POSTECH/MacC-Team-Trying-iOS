//
//  EnterCodeViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/24.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EnterCodeCoordinatorLogic {
    func coordinateToSignUpEnterPassword()
}

protocol EnterCodeBuisnessLogic: BusinessLogic {
    func nextButtonDidTapped()
}

final class EnterCodeViewModel: BaseViewModel, EnterCodeBuisnessLogic {
    let coordinator: EnterCodeCoordinatorLogic

    init(coordinator: EnterCodeCoordinatorLogic) {
        self.coordinator = coordinator
    }

    func nextButtonDidTapped() {
        coordinator.coordinateToSignUpEnterPassword()
    }
}

extension EnterCodeViewModel {
    var rightCode: String {
        return "aaaaaa"
    }
}
