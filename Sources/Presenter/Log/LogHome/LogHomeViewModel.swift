//
//  LogHomeViewModel.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/07.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

protocol TicketViewCoodinating {
    func presentTicketViewController()
}
protocol MyConstellationViewCoordinating {
    func pushMyConstellationViewController()
}

final class LogHomeViewModel: BaseViewModel {
    var coordinator: Coordinator
    
    var place = [Place]()
    
    init(coordinator: Coordinator) {
        self.coordinator = coordinator
        super.init()
    }
}

extension LogHomeViewModel {
    func pop() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    func pushMyConstellationView() {
        guard let coordinator = coordinator as? MyConstellationViewCoordinating else { return }
        coordinator.pushMyConstellationViewController()
    }
    func presentTicketView() {
        guard let coordinator = coordinator as? TicketViewCoodinating else { return }
        coordinator.presentTicketViewController()
    }
    
}
