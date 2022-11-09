//
//  EditDayViewModel.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/09.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation

import CancelBag

final class EditDayViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
    }
}

// MARK: - Coordinating
extension EditDayViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
}
