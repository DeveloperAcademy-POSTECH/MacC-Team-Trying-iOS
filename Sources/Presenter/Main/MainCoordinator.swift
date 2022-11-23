//
//  MainCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

protocol Popable {
    func popViewController()
}
protocol MainCoordinatorDelegate: AnyObject {
    func coordinateToLoginSceneFromProfile()
}
protocol MoveToHomeTap: AnyObject {
    func moveToHomeTap(course: CourseEntity)
}

final class MainCoordinator: Coordinator {
    
    // MARK: 알림에서 log로 이동해야하는 로직이 있을때 필요. refactoring todo
    var logCoordinator: LogCoordinator?
    
    // MARK: 알림 푸쉬왔을때 Home root로 오기위해 필요. HomeCoordinator에서 weak으로 되어있음. refactoring todo
    var homeCoordinator: HomeCoordinator?
    
    enum TabBarItem: CaseIterable {
        case home
        case log
        case profile
        
        var title: String {
            switch self {
            case .home:
                return Constants.Coordinator.home

            case .log:
                return Constants.Coordinator.log
                
            case .profile:
                return Constants.Coordinator.profile
            }
        }
        
        var tabBarIconName: String {
            switch self {
            case .home:
                return Constants.Coordinator.homeIcon
                
            case .log:
                return Constants.Coordinator.logIcon
                
            case .profile:
                return Constants.Coordinator.profileIcon
            }
        }
        
        func getCoordinator(navigationController: UINavigationController) -> Coordinator {
            switch self {
            case .home:
                return HomeCoordinator(navigationController: navigationController)
                
            case .log:
                return LogCoordinator(navigationController: navigationController)
                
            case .profile:
                return ProfileCoordinator(navigationController: navigationController)
            }
        }
    }
    
    weak var navigationController: UINavigationController?
    weak var delegate: MainCoordinatorDelegate?

    let tabBarController: UITabBarController
    let tabBarItems: [TabBarItem] = [.home, .log, .profile]

    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
        self.tabBarController = UITabBarController()
    }
    
    func start() {
        let controllers = tabBarItems.map { getTabController(item: $0) }
        prepareTabBarController(with: controllers)
    }
}

// MARK: - Helper Methods
extension MainCoordinator {
    private func getTabController(item: TabBarItem) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.setNavigationBarHidden(false, animated: false)
        let tabItem = UITabBarItem(title: item.title, image: UIImage(named: item.tabBarIconName), selectedImage: nil)
        
        navigationController.tabBarItem = tabItem
        
        let coordinator = item.getCoordinator(navigationController: navigationController)
        
        if item == .home {
            if let coordinator = coordinator as? HomeCoordinator {
                coordinator.parentCoordinator = self
                // MARK: 서로 참조. 하나는 weak. refactoring 필요.
                homeCoordinator = coordinator
            }
        } else if item == .profile {
            if let coordinator = coordinator as? ProfileCoordinator {
                coordinator.delegate = self
            }
        } else if item == .log {
            if let coordinator = coordinator as? LogCoordinator {
                logCoordinator = coordinator
                coordinator.parentCoordinator = self
            }
        }
        
        coordinator.start()
        
        return navigationController
    }
    
    private func prepareTabBarController(with tabControllers: [UIViewController]) {
        guard let navigationController = navigationController else { return }
        tabBarController.tabBar.backgroundColor = .black
        tabBarController.tabBar.tintColor = UIColor(named: "mainYellow")
        tabBarController.tabBar.unselectedItemTintColor = .white
        tabBarController.tabBar.barTintColor = .black
        tabBarController.setViewControllers(tabControllers, animated: false)
        navigationController.setNavigationBarHidden(true, animated: true)
        navigationController.setViewControllers([tabBarController], animated: true) 
    }
}

protocol MoveToAnotherTab: AnyObject {
    func moveToLogTab()
}

extension MainCoordinator: MoveToAnotherTab {
    func moveToLogTab() {
        tabBarController.selectedIndex = 1
        logCoordinator?.navigationController?.popToRootViewController(animated: false)
    }
}

extension MainCoordinator: ProfileCoordinatorDelegate {
    func coordinateToLoginScene() {
        print("coordinateToLoginScene")
        delegate?.coordinateToLoginSceneFromProfile()
    }
}

extension LogCoordinator {
    func popToRootViewController() {
        navigationController?.popToRootViewController(animated: false)
    }
}

extension MainCoordinator: MoveToHomeTap {
    func moveToHomeTap(course: CourseEntity) {
        tabBarController.selectedIndex = 0
        logCoordinator?.navigationController?.popToRootViewController(animated: false)

        let places = course.places.map { place in
            let resultPlace = Place(
                id: place.id,
                title: place.title,
                category: place.category,
                address: place.address,
                location: place.coordinate
            )
            return resultPlace
        }

        let courseRequestDTO = CourseRequestDTO(
            id: course.id,
            title: course.courseTitle,
            date: course.date,
            places: places
        )

        homeCoordinator?.startRegisterReviewFlow(courseRequestDTO: courseRequestDTO)
    }
}
