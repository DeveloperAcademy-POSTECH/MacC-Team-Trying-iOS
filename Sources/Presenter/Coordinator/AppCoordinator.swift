//
//  AppCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit
import Combine

final class AppCoordinator: Coordinator, IntroCoordinatorDelegate, MainCoordinatorDelegate {
    let window: UIWindow
    weak var navigationController: UINavigationController?
    let userService: UserService = UserService()
    var mainCoordinator: MainCoordinator?
//    var go: Bool = false
    
    // MARK: 동작은 하나, 이쁘지 않은 코드
    @Published var isMainCoordinatorMade: Bool = false
    
    init(window: UIWindow) {
        self.window = window
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(true, animated: false)
        
        self.navigationController = navigationController
    }
    
    func start() {
        
        window.rootViewController = navigationController

        Task {
            do {
                let userInformations = try await userService.getUserInformations()
                if userInformations.planet == nil {
                    await coordinateToCreatePlanet()
                } else if userInformations.mate == nil {
                    guard let planet = userInformations.planet else { return }
                    if planet.hasBeenMateEntered {
                        await coordinateToWarningMateExitScene()
                    } else {
                        await coordinateToWaitingMate(
                            selectedPlanet: planet.image,
                            planetName: planet.name,
                            code: planet.code ?? ""
                        )
                    }
                    return
                } else {
                    await coordinateToMainScene()
                    isMainCoordinatorMade = true
                }
            } catch {
                await coordinateToLogincScene()
            }
        }
    }
    
    func presentSplashView() {
        let viewModel = SplashViewModel(coordinator: self)
        let viewController = SplashViewController(viewModel: viewModel)
        
        self.navigationController?.setViewControllers([viewController], animated: false)
        
        window.rootViewController = navigationController
        window.makeKeyAndVisible()
    }

    @MainActor
    func coordinateToMainScene() {
//        guard go == false else { return }
//        go = true
        if mainCoordinator != nil { return }
        mainCoordinator = MainCoordinator(navigationController: navigationController)
        guard let mainCoordinator = mainCoordinator else { return }
        mainCoordinator.start()
        mainCoordinator.delegate = self
        window.makeKeyAndVisible()
    }

    @MainActor
    func coordinateToLogincScene() {
        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinator.delegate = self
        window.makeKeyAndVisible()
    }

    func coordinateToLogincSceneByDispatchQueue() {
        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.start()
        coordinator.delegate = self
        window.makeKeyAndVisible()
    }

    @MainActor
    private func coordinateToCreatePlanet() {
        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.startWithCreatePlanet()
        coordinator.delegate = self
        window.makeKeyAndVisible()
    }

    @MainActor
    private func coordinateToWaitingMate(selectedPlanet: String, planetName: String, code: String) {
        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.startWithWaitingMate(selectedPlanet: selectedPlanet, planetName: planetName, code: code)
        coordinator.delegate = self
        window.makeKeyAndVisible()
    }

    func coordinateToLoginSceneFromProfile() {
        self.coordinateToLogincSceneByDispatchQueue()
    }

    @MainActor
    private func coordinateToWarningMateExitScene() {
        let coordinator = IntroCoordinator(navigationController: navigationController)
        coordinator.startWithUserWarningExitPlanet()
        window.makeKeyAndVisible()
    }
}
