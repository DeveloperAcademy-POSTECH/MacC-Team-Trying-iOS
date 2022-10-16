//
//  EnterEmailViewModel.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/14.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

import CancelBag

protocol EnterEmailCoordinatorLogic {}

final class EnterEmailViewModel: BaseViewModel {
    let coordinator: EnterEmailCoordinatorLogic

    init(coordinator: EnterEmailCoordinatorLogic) {
        self.coordinator = coordinator
    }
}
