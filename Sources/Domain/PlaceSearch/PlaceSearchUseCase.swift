//
//  PlaceSearchUseCase.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

protocol PlaceSearchRepository {
    // func getAddressUsingKakao(coordinate: CLLocationCoordinate2D) async throws -> String
    func searchPlaceUsingKakao(query: String, coordinate: CLLocationCoordinate2D) async throws -> [Place]
}

protocol PlaceSearchUseCase {
    // func getAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> String
    func searchPlace(query: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Place]
}

final class PlaceSearchUseCaseImpl: PlaceSearchUseCase {
    private let placeSearchRepository: PlaceSearchRepository
    
    init(placeSearchRepository: PlaceSearchRepository = PlaceSearchRepositoryImpl()) {
        self.placeSearchRepository = placeSearchRepository
    }
    
    func searchPlace(query: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Place] {
        return try await self.placeSearchRepository.searchPlaceUsingKakao(query: query, coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    /*
    func getAddress(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> String {
        return try await self.placeSearchRepository.getAddressUsingKakao(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    */
}
