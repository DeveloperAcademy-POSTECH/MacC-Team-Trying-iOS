//
//  ProfileCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol ProfileCoordinatorDelegate: AnyObject {
    func coordinateToLoginScene()
}

final class ProfileCoordinator: Coordinator {
    weak var navigationController: UINavigationController?

    var delegate: ProfileCoordinatorDelegate?

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start() {
        guard let navigationController = navigationController else { return }
        let viewModel = ProfileViewModel(coordinator: self)
        let viewController = ProfileViewController(viewModel: viewModel)
        
        navigationController.pushViewController(viewController, animated: true)
    }
}

// MARK: - Coordinating Methods
extension ProfileCoordinator: ProfileCoordinatorLogic, Popable, EditProfileCoordinatorLogic, EditNicknamCoordinatorLogic, EditPasswordCoordinatorLogic, EditPlanetCoordinatorLogic {

    func pushToEditDayView() {
        let viewModel = EditDayViewModel(coordinator: self)
        let viewController = EditDayViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popViewController() {
        navigationController?.popViewController(animated: true)
    }

    func coordinateToEditProfile() {
        let editProfile = EditProfileViewController(viewModel: .init(coordinator: self))
        editProfile.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editProfile, animated: true)
    }

    func back() {
        self.navigationController?.popViewController(animated: true)
    }

    func coordinateToEditNicknameScene(nickname: String) {
        let editNickname = EditNicknameViewController(viewModel: .init(nickname: nickname, coordinator: self))
        editNickname.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editNickname, animated: true)
    }

    func coordinateToEditPasswordScene() {
        let editPassword = EditPasswordViewController(viewModel: .init(coordinator: self))
        editPassword.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editPassword, animated: true)
    }
    
    func coordinateToLoginScene() {
        delegate?.coordinateToLoginScene()
    }

    func coordinateToEditPlanet(date: String, planetName: String, planetImageName: String) {
        let editPlanet = EditPlanetViewController(viewModel: .init(date: date, planetName: planetName, planetImage: planetImageName, coordinator: self))
        editPlanet.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(editPlanet, animated: true)
    }
    
    func coordinateToDeRegisterScene() {
        let withdrwalViewController = UserWarningViewController(outgoingType: .membershipWithdrawal)
        withdrwalViewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(withdrwalViewController, animated: true)
    }
    
    func coordinateToExitPlanet(type: OutgoingType) {
        let exitPlanetViewController = UserWarningViewController(outgoingType: .exitPlanet)
        exitPlanetViewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(exitPlanetViewController, animated: true)
    }
    
    func pushToServiceTermView() {
        let viewController = TermViewController(viewModel: .init())
        viewController.termType = .service
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

extension ProfileCoordinator: EditNotificationCoordinating {
    func pushToEditNotificationView() {
        let viewModel = PushNotificationsViewModel(coordinator: self)
        let viewController = PushSettingsViewController(viewModel: viewModel)
        viewController.hidesBottomBarWhenPushed = true
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

protocol EditNotificationCoordinating {
    func pushToEditNotificationView()
}
