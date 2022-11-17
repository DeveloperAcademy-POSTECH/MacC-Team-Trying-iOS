//
//  MyConstellationViewModel.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Combine
import Foundation

final class MyConstellationViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    let courses: [TestCourse]
    
    init(coordinator: Coordinator, courses: [TestCourse]) {
        self.coordinator = coordinator
        self.courses = courses
        super.init()
    }
}

extension MyConstellationViewModel {
    // MARK: Dismiss Action
    func tapDismissButton() {
        guard let coordinator = coordinator as? Popable else { return }
        coordinator.popViewController()
    }
    
    // MARK: MapViewContoller 전환
    func pushLogMapViewController() {
        guard let coordinator = coordinator as? LogMapViewCoordinating else { return }
        coordinator.pushLogMapViewController()
    }
}
