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
        
        func getCoordinator(presenter: UINavigationController) -> Coordinator {
            switch self {
            case .home:
                return HomeCoordinator(presenter: presenter)
            case .search:
                return SearchCoordinator(presenter: presenter)
            case .feed:
                return FeedCoordinator(presenter: presenter)
            case .profile:
                return ProfileCoordinator(presenter: presenter)
            }
        }
    }
    
    weak var presenter: UINavigationController?
    
    var tabBarController: UITabBarController
    var tabBarItems: [TabBarItem] = [ .home, .search, .feed, .profile]
    
    init(presenter: UINavigationController?) {
        self.presenter = presenter
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
        let tabItem = UITabBarItem(title: item.title, image: UIImage(named: item.tabBarIconName), selectedImage: nil)
        navigationController.tabBarItem = tabItem
        
        let coordinator = item.getCoordinator(presenter: navigationController)
        coordinator.start()
        
        return navigationController
    }
    
    private func prepareTabBarController(with tabControllers: [UIViewController]) {
        guard let presenter = presenter else { return }
        tabBarController.setViewControllers(tabControllers, animated: false)
        presenter.viewControllers = [tabBarController]
    }
}
