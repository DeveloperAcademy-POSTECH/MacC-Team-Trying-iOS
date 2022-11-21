//
//  RegisterReviewCoordinator.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

protocol RegisterReviewCoordinating {
    /// 완료 화면으로 이동합니다.
    /// - Parameter courseRequestDTO: 코스 관련 API 통신을 위한 DTO
    func pushToCompleteView(_ courseRequestDTO: CourseRequestDTO)
    
    /// 완료 화면에서 홈 화면으로 이동합니다.
    func popToHomeView()
    
    /// 이전 화면으로 이동합니다.
    func popViewController()
}

final class RegisterReviewCoordinator: CourseFlowCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(_ courseRequestDTO: CourseRequestDTO) {
        let viewModel = RegisterReviewViewModel(coordinator: self, courseRequestDTO: courseRequestDTO)
        let viewController = RegisterReviewViewController(viewModel: viewModel)
        
        viewController.hidesBottomBarWhenPushed = true
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Coordinating
extension RegisterReviewCoordinator: RegisterReviewCoordinating {
    func pushToCompleteView(_ courseRequestDTO: CourseRequestDTO) {
        let viewModel = CourseCompleteViewModel(coordinator: self, courseRequestDTO: courseRequestDTO)
        let viewController = CourseCompleteViewController(type: .registerReview, viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popToHomeView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
