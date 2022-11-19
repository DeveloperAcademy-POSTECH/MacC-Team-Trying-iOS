//
//  EditPlanCoordinator.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation
import UIKit

protocol EditPlanCoordinating: CourseFlowCoordinator {
    /// 장소를 선택하기 위한 지도 화면으로 이동합니다.
    /// - Parameter courseRequestDTO: 코스 관련 API 통신을 위한 DTO
    func pushToCourseMapView(_ courseRequestDTO: CourseRequestDTO)
    
    /// 장소 검색 화면으로 이동합니다.
    func pushToPlaceSearchView()
    
    /// 장소 검색 결과를 보여주는 지도 화면으로 이동합니다.
    /// - Parameters:
    ///   - searchText: 검색한 문자열
    ///   - searchedPlaces: 검색 결과의 장소들
    ///   - presentLocation: 지도에서 처음 보여줄 위치
    func pushToPlaceSearchResultMapView(searchText: String, searchedPlaces: [Place], presentLocation: CLLocationCoordinate2D)
    
    /// 장소 검색 결과를 보여주는 지도 화면에서 선택한 장소들을 볼 수 있는 지도 화면으로 이동합니다.
    func dismissToPlaceSearchMapView()
    
    /// 완료 화면으로 이동합니다.
    /// - Parameter courseRequestDTO: 코스 관련 API 통신을 위한 DTO
    func pushToCompleteView(_ courseRequestDTO: CourseRequestDTO)
    
    /// 완료 화면에서 홈 화면으로 이동합니다.
    func popToHomeView()
    
    /// 이전 화면으로 이동합니다.
    func popViewController()
}

final class EditPlanCoordinator: CourseFlowCoordinator {
    weak var navigationController: UINavigationController?
    
    init(navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    func start(_ courseRequestDTO: CourseRequestDTO) {
        let viewModel = CourseTitleViewModel(coordinator: self, courseRequestDTO: courseRequestDTO)
        let viewController = CourseTitleViewController(type: .addCourse, viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
}

// MARK: - Coordinating
extension EditPlanCoordinator: EditPlanCoordinating {
    func pushToCourseMapView(_ courseRequestDTO: CourseRequestDTO) {
        let viewModel = CourseMapViewModel(coordinator: self, courseRequestDTO: courseRequestDTO)
        let viewController = CourseMapViewController(viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func pushToPlaceSearchView() {
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
    
    func pushToCompleteView(_ courseRequestDTO: CourseRequestDTO) {
        let viewModel = CourseCompleteViewModel(coordinator: self, courseRequestDTO: courseRequestDTO)
        let viewController = CourseCompleteViewController(type: .addCourse, viewModel: viewModel)
        
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    func popToHomeView() {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func popViewController() {
        self.navigationController?.popViewController(animated: true)
    }
}
