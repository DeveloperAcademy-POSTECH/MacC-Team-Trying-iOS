//
//  HomeCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class HomeCoordinator: Coordinator {
    weak var presenter: UINavigationController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {
        guard let presenter = presenter else { return }
        let viewController = TestViewController()
        let viewModel = TestViewModel()
        viewController.viewModel = viewModel
        
        presenter.pushViewController(viewController, animated: true)
    }
}
