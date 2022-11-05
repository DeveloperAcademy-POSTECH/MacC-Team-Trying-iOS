//
//  AddCourseCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/24.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

enum AddCourseFlowType {
    case plan
    case record
}

final class AddCourseCoordinator: Coordinator,
                                  AddCourseMapCoordinating,
                                  PlaceSearchCoordinating,
                                  RecordCourseCoordinating,
                                  AddCourseCompleteCoordinating,
                                  HomeCoordinating,
                                  Popable {
    var type: AddCourseFlowType
    weak var navigationController: UINavigationController?
    
    init(type: AddCourseFlowType, navigationController: UINavigationController?) {
        self.type = type
        self.navigationController = navigationController
    }
    
    func start() {
        let viewModel = AddCourseTitleViewModel(coordinator: self)
        let viewController = AddCourseTitleViewController(type: type, viewModel: viewModel)
        
//        self.navigationController?.tabBarController?.tabBar.isHidden = true
        self.navigationController?.pushViewController(viewController, animated: true)
        
        /*
        let viewModel = AddCourseMapViewModel(coordinator: self)
        let viewController = AddCourseMapViewController(flow: flow, viewModel: viewModel)
        
        self.navigationController?.isNavigationBarHidden = false
        self.navigationController?.pushViewController(viewController, animated: true)
        */
    }
    
    func pushToAddCourseMapViewController(courseTitle: String) {
        let viewModel = AddCourseMapViewModel(coordinator: self, courseTitle: courseTitle)
        let viewController = AddCourseMapViewController(type: type, viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToPlaceSearchViewController() {
        let viewModel = PlaceSearchViewModel(coordinator: self)
        let viewController = PlaceSearchViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToRecordCourseViewController(places: [Place]) {
        let viewModel = RecordCourseViewModel(coordinator: self, places: places, courseTitle: "Temp Title")
        let viewController = RecordCourseViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToAddCourseCompleteViewController(courseTitle: String, courseContent: String, isPublic: Bool, places: [Place], images: [UIImage]) {
        let viewModel = AddCourseCompleteViewModel(
            coordinator: self,
            courseTitle: courseTitle,
            courseContent: courseContent,
            isPublic: isPublic,
            places: places,
            images: images
        )
        let viewController = AddCourseCompleteViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popToHomeViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
