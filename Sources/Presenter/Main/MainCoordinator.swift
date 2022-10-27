//
//  MainCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class MainCoordinator: Coordinator {
    enum TabBarItem: CaseIterable {
        case home
        case search
        case feed
        case profile
        
        var title: String {
            switch self {
            case .home:
                return Constants.Coordinator.home
                
            case .search:
                return Constants.Coordinator.search
                
            case .feed:
                return Constants.Coordinator.feed
                
            case .profile:
                return Constants.Coordinator.profile
            }
        }
        
        var tabBarIconName: String {
            switch self {
            case .home:
                return Constants.Coordinator.homeIcon
                
            case .search:
                return Constants.Coordinator.searchIcon
                
            case .feed:
                return Constants.Coordinator.feedIcon
                
            case .profile:
                return Constants.Coordinator.profileIcon
            }
        }
        
        func getCoordinator(navigationController: UINavigationController) -> Coordinator {
            switch self {
            case .home:
                return HomeCoordinator(navigationController: navigationController)
                
            case .search:
                return SearchCoordinator(navigationController: navigationController)
                
            case .feed:
                return FeedCoordinator(navigationController: navigationController)
                
            case .profile:
                return ProfileCoordinator(navigationController: navigationController)
            }
        }
    }
    
    weak var navigationController: UINavigationController?
    
    let tabBarController: UITabBarController
    let tabBarItems: [TabBarItem] = [ .home, .search, .feed, .profile]
    
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
