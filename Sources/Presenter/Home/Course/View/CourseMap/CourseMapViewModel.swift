//
//  CourseMapViewModel.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/19.
//  Copyright (c) 2022 Try-ing. All rights reserved.
//

import Combine
import CoreLocation
import MapKit

import CancelBag

final class CourseMapViewModel: BaseViewModel {
    var coordinator: CourseFlowCoordinator
    
    private let addCourseUseCase: AddCourseUseCase
    private let editCourseUseCase: EditCourseUseCase
    
    var courseRequestDTO: CourseRequestDTO
    @Published var places: [Place] {
        didSet {
            self.courseRequestDTO.places = self.places
        }
    }
    // @Published var memo: String?
    
    init(
        coordinator: CourseFlowCoordinator,
        addCourseUseCase: AddCourseUseCase = AddCourseUseCaseImpl(addCourseRepository: AddCourseRepositoryImpl()),
        editCourseUseCase: EditCourseUseCase = EditCourseUseCaseImpl(editCourseRepository: EditCourseRepositoryImpl()),
        courseRequestDTO: CourseRequestDTO
    ) {
        self.coordinator = coordinator
        self.addCourseUseCase = addCourseUseCase
        self.editCourseUseCase = editCourseUseCase
        self.courseRequestDTO = courseRequestDTO
        
        self.places = courseRequestDTO.places
    }
}

// MARK: - Business Logic
extension CourseMapViewModel {
    func addPlace(_ place: Place) {
        /*
        var selectedPlace = place
        selectedPlace.memo = self.memo
        places.append(selectedPlace)
        self.memo = nil
         */
        self.places.append(place)
        self.courseRequestDTO.places = self.places
    }
    
    func deletePlace(_ index: Int) {
        places.remove(at: index)
    }
    
    func changePlaceOrder(sourceIndex: Int, to destinationIndex: Int) {
        let targetPlace = places[sourceIndex]
        places.remove(at: sourceIndex)
        places.insert(targetPlace, at: destinationIndex)
    }
    
    func addCourse() async throws -> Int {
        return try await self.addCourseUseCase.addCourse(courseRequestDTO: self.courseRequestDTO)
    }
    
    func editCourse() async throws -> Int {
        return try await self.editCourseUseCase.editCourse(self.courseRequestDTO)
    }
}

// MARK: - Coordinating
extension CourseMapViewModel {
    func pop() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.popViewController()
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.popViewController()
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.popViewController()
            
        case is EditPlanCoordinator:
            guard let coordinator = self.coordinator as? EditPlanCoordinator else { return }
            coordinator.popViewController()
            
        default:
            break
        }
    }
    
    func pushToPlaceSearchView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        case is EditPlanCoordinator:
            guard let coordinator = self.coordinator as? EditPlanCoordinator else { return }
            coordinator.pushToPlaceSearchView()
            
        default:
            break
        }
    }
    
    func pushToNextView() {
        switch self.coordinator {
        case is AddCourseCoordinator:
            guard let coordinator = self.coordinator as? AddCourseCoordinator else { return }
            Task {
                do {
                    self.courseRequestDTO.id = try await self.addCourse()
                    
                    DispatchQueue.main.async {
                        coordinator.pushToRegisterReviewView(self.courseRequestDTO)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        case is EditCourseCoordinator:
            guard let coordinator = self.coordinator as? EditCourseCoordinator else { return }
            Task {
                do {
                    _ = try await self.editCourse()
                    
                    DispatchQueue.main.async {
                        coordinator.pushToCompleteView(self.courseRequestDTO)
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
            
        case is AddPlanCoordinator:
            guard let coordinator = self.coordinator as? AddPlanCoordinator else { return }
            coordinator.pushToCompleteView(self.courseRequestDTO)
            
        case is EditPlanCoordinator:
            guard let coordinator = self.coordinator as? EditPlanCoordinator else { return }
            coordinator.pushToCompleteView(self.courseRequestDTO)
            
        default:
            break
        }
    }
}
