//
//  MyConstellationViewModel.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/08.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

final class MyConstellationViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
}

extension MyConstellationViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
}
