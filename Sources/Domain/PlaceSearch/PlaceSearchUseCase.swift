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
    /// 이름으로 장소들을 검색하여, 현재 위치로부터 가까운 장소들을 반환합니다.
    /// - Parameters:
    ///   - name: 검색할 이름
    ///   - latitude: 현재 위치의 위도
    ///   - longitude: 현재 위치의 경도
    /// - Returns: 현재 위치와 가까운 장소들
    func placeSearch(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> PlaceSearchResponse
    
    /// 위치로 장소들을 검색합니다.
    /// - Parameters:
    ///   - distance: 지정한 위치로부터 결과를 나타낼 반경 (km 단위)
    ///   - latitude: 검색할 위치의 위도
    ///   - longitude: 검색할 위치의 경도
    /// - Returns: 검색 결과의 장소들
    func placeSearch(distance: Double, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> PlaceSearchResponse
}

protocol PlaceSearchUseCase {
    func placeSearch(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Place]
    
    func placeSearch(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Place]
}

final class PlaceSearchUseCaseImpl: PlaceSearchUseCase {
    private let placeSearchRepository: PlaceSearchRepository
    
    init(placeSearchRepository: PlaceSearchRepository = PlaceSearchRepositoryImpl()) {
        self.placeSearchRepository = placeSearchRepository
    }
    
    func placeSearch(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Place] {
        let response = try await placeSearchRepository.placeSearch(name: name, latitude: latitude, longitude: longitude)
        
        print("🔥🔥🔥🔥🔥name search")
        print("🔥name : \(name)")
        dump(self.convertToModel(response))
        print("🔥🔥🔥🔥🔥")
        print("")

        return self.convertToModel(response)
    }
    
    func placeSearch(latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> [Place] {
        let distance = 0.05
        let response = try await placeSearchRepository.placeSearch(distance: distance, latitude: latitude, longitude: longitude)
        
        print("✨\(self.convertToModel(response))")
        
        return self.convertToModel(response)
    }
}

// MARK: - Convert Method
extension PlaceSearchUseCaseImpl {
    private func convertToModel(_ response: PlaceSearchResponse) -> [Place] {
        var places = [Place]()
        
        response.contents.forEach { content in
            places.append(
                Place(
                    id: content.place.placeId,
                    title: content.place.name,
                    // FIXME: API 수정 후 카테고리 수정
                    category: "임시 카테고리",
                    address: "임시 주소",
                    location: CLLocationCoordinate2D(
                        latitude: content.place.coordinate.latitude,
                        longitude: content.place.coordinate.longitude
                    ),
                    memo: nil
                )
            )
        }
        
        return places
    }
}
