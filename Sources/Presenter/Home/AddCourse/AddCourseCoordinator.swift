//
//  AddCourseCoordinator.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/24.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import UIKit

final class AddCourseCoordinator: Coordinator,
                                  AddCourseMapCoordinating,
                                  PlaceSearchCoordinating,
                                  PlaceSearchResultMapViewCoordinating,
                                  PlaceSearchResultMapViewDismissable,
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
    
    func pushToPlaceSearchResultMapView(searchText: String, searchedPlaces: [Place], presentLocation: CLLocationCoordinate2D) {
        let viewModel = PlaceSearchResultMapViewModel(coordinator: self)
        let viewController = PlaceSearchResultMapViewController(searchText: searchText, searchedPlaces: searchedPlaces, presentLocation: presentLocation, viewModel: viewModel)
        
        guard let previousViewController = navigationController?.viewControllers.last(where: { $0 != navigationController?.topViewController }) as? AddPlaceDelegate else { return }
        viewController.delegate = previousViewController
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func dismissToPlaceSearchMapView() {
        self.navigationController?.popViewController(animated: false)
        self.navigationController?.popViewController(animated: false)
    }
    
    func pushToRecordCourseViewController(courseTitle: String, places: [Place]) {
        let viewModel = RecordCourseViewModel(coordinator: self, courseTitle: courseTitle, places: places)
        let viewController = RecordCourseViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToAddCourseCompleteViewController(courseTitle: String, courseContent: String, places: [Place], images: [UIImage], isPublic: Bool) {
        let viewModel = AddCourseCompleteViewModel(
            coordinator: self,
            courseTitle: courseTitle,
            courseContent: courseContent,
            isPublic: isPublic,
            places: places,
            images: images
        )
        let viewController = AddCourseCompleteViewController(type: type, viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popToHomeViewController() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
