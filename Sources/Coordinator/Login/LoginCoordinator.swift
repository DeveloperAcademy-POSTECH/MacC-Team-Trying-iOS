//
//  LoginCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/12.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class LoginCoordinator: Coordinator {
    weak var presenter: UINavigationController?
    
    init(presenter: UINavigationController) {
        self.presenter = presenter
    }
    
    func start() {

    }
}
