//
//  LogImageFullScreenViewModel.swift
//  우주라이크
//
//  Created by YeongJin Jeong on 2022/12/05.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine

final class LogImageFullScreenViewModel: BaseViewModel {
    
    var coordinator: Coordinator
    
    let imageUrl: [String]
    
    private let rootViewState: RootViewState
    
    private let selectedCourseIndex: Int
    
    private let course: CourseEntity
    
    init(
        coordinator: Coordinator,
        imageUrl: [String],
        rootViewState: RootViewState,
        selectedCourseIndex: Int,
        course: CourseEntity
    ) {
        self.coordinator = coordinator
        self.imageUrl = imageUrl
        self.rootViewState = rootViewState
        self.selectedCourseIndex = selectedCourseIndex
        self.course = course
    }
}

// MARK: Coordinating
extension LogImageFullScreenViewModel {
    func dismissViewController() {
        guard let coordinator = coordinator as? DismissCoordinating else { return }
        coordinator.dismissTicketViewController()
    }
    
    func pushLogTicketViewController() {
        guard let coordinator = coordinator as? TicketViewCoodinating else { return }
        coordinator.presentTicketViewController(course: course, selectedCourseIndex: selectedCourseIndex, rootViewState: rootViewState)
    }
}
