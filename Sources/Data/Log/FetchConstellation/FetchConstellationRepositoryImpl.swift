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
    
    func fetchLogAsyc() async throws -> [TestCourse] {
        
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
    private func convertToTestCourse(_ responseData: FetchConstellationDTO) -> [TestCourse] {
        
        var courses = [TestCourse]()
        responseData.courses.forEach { course in
            var places = [Place]()
            course.places.forEach { place in
                let place = Place(
                    title: place.place.name,
                    category: "none",
                    address: place.place.address,
                    location: CLLocationCoordinate2D(latitude: place.place.coordinate.latitude, longitude: place.place.coordinate.longitude),
                    memo: place.memo
                )
                places.append(place)
            }
            let course = TestCourse(
                places: places,
                courseName: course.title,
                date: course.title
            )
            courses.append(course)
        }
        return courses
    }
}
// TODO: 삭제할 코드
struct TestCourse {
    let places: [Place]
    let courseName: String
    let date: String
}
