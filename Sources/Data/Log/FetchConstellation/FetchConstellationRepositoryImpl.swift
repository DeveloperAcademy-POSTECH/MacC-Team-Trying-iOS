//
//  DefaultConstellationRepository.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import CoreLocation

enum LogRequestError: Error {
    case urlResponse
    case response
}

final class FetchConstellationRepositoryImpl {
    
    let url = "https://comeit.site/courses/log?page=0&size=10"
    
    private let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2MjYyMTA0MS01NTI2LTRjZjgtOGJiOC0xMzdlODhmMDExYWEiLCJhdXRoIjoiVVNFUiJ9._hKs0Sr0JQDKF_-2XjubIp3OTHwwR6Tme4TgZ6PjGgE23oi_gPj2eglZP9w4IVaT7uyk2eYucbdL4zKXVQ9TuQ"
}

extension FetchConstellationRepositoryImpl: FetchConstellationRepository {
    
    func fetchLogAsync() async throws -> [CourseEntity] {
        
        guard let url = URL(string: url) else {
            print("################## LOG URL ERROR #######################")
            throw LogRequestError.urlResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("api response error", response)
            
            throw LogRequestError.response
        }
        
        let responseData = try JSONDecoder().decode(FetchConstellationDTO.self, from: data)
        
        return convertToTestCourse(responseData)
    }
    
    // MARK: DTO를 Entity로 변환 -> 추후 수정예정
    private func convertToTestCourse(_ responseData: FetchConstellationDTO) -> [CourseEntity] {
        
        var courses = [CourseEntity]()
        
        responseData.courses.forEach { course in
            var places = [PlaceEntity]()
            course.places.forEach { placeElement in
                let place = PlaceEntity(
                    id: placeElement.place.placeId,
                    title: placeElement.place.name,
                    category: "none",
                    address: placeElement.place.address,
                    coordinate: CLLocationCoordinate2D(latitude: placeElement.place.coordinate.latitude, longitude: placeElement.place.coordinate.longitude),
                    memo: placeElement.memo
                )
                places.append(place)
            }
            
            let tempCource = CourseEntity(
                id: course.courseId,
                courseTitle: course.title,
                date: course.date,
                places: places
            )
            courses.append(tempCource)
        }
        return courses
    }
}
