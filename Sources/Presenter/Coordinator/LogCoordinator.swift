//
//  LogCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//
import UIKit

final class LogCoordinator: Coordinator,
                            MyConstellationViewCoordinating,
                            TicketViewCoodinating,
                            DismissCoordinating,
                            Popable,
                            LogFullImageCoordinating {
    weak var navigationController: UINavigationController?
    
    weak var parentCoordinator: MoveToHomeTap?
    
    init(navigationController: UINavigationController) { self.navigationController = navigationController }
    
    // MARK: Coordinating functions
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = LogHomeViewModel(coordinator: self)
        let viewController = LogHomeViewController(viewModel: viewModel)
        navigationController.pushViewController(viewController, animated: true)
    }
    // TicketView로 전환
    func presentTicketViewController(course: CourseEntity, selectedCourseIndex: Int, rootViewState: RootViewState) {
        let viewModel = LogTicketViewModel(coordinator: self, course: course, selectedCourseIndex: selectedCourseIndex)
        let viewController = LogTicketViewController(viewModel: viewModel, rootViewState: rootViewState)
        navigationController?.present(viewController, animated: true)
    }
    
    func pushMyConstellationViewController(courses: [CourseEntity], homeView: LogHomeViewController) {
        let viewModel = MyConstellationViewModel(coordinator: self, courses: courses)
        let viewController = MyConstellationViewController(viewModel: viewModel)
        viewController.homeView = homeView
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismissTicketViewController() {
        self.navigationController?.dismiss(animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func presentImageFullScreenViewController(imageUrl: [String], rootViewState: RootViewState, course: CourseEntity, selectedCourseIndex: Int, currentImageIndex: Int) {
        let viewModel = LogImageFullScreenViewModel(coordinator: self, imageUrl: imageUrl, rootViewState: rootViewState, selectedCourseIndex: selectedCourseIndex, course: course )
        let viewController = LogImageFullScreenViewController(viewModel: viewModel, currentImageIndex: currentImageIndex)
        viewController.modalPresentationStyle = .fullScreen
        navigationController?.present(viewController, animated: true)
    }
    
    func startEditReviewCoordinator(courseRequestDTO: CourseRequestDTO, images: [UIImage], reviewContent: String?) {
        let registerReviewCoordinator = RegisterReviewCoordinator(navigationController: navigationController, type: .edit)
        
        registerReviewCoordinator.start(courseRequestDTO, images: images, reviewContent: reviewContent)
    }
    
    func startLogMapFlow(courses: [CourseEntity]) {
        let coordinator = LogMapCoordinator(navigationController: navigationController)
        coordinator.start(courses: courses)
    }
}

protocol MoveFromLogToHome {
    func goToHomeView(course: CourseEntity)
}

extension LogCoordinator: MoveFromLogToHome {
    func goToHomeView(course: CourseEntity) {
        DispatchQueue.main.async {
            self.navigationController?.dismiss(animated: true)
            self.parentCoordinator?.moveToHomeTap(course: course)
        }
    }
}
