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
    case decoding
}

final class FetchConstellationRepositoryImpl {
    
    let url = "\(APIManager.baseURL)/courses/log?page=0&size=10"
    
    private let token = UserDefaults.standard.string(forKey: "accessToken")
    
}

extension FetchConstellationRepositoryImpl: FetchConstellationRepository {
    
    func fetchLogAsync() async throws -> [CourseEntity] {
        
        guard let url = URL(string: url) else {
            #if DEBUG
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("fetchLogAsync: URL Error occured")
            #endif
            throw LogRequestError.urlResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            #if DEBUG
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("fetchLogAsync: API Response Error")
            print(response)
            #endif
            throw LogRequestError.response
        }
        
        guard let responseData = try? JSONDecoder().decode(FetchConstellationDTO.self, from: data) else {
            #if DEBUG
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("fetchLogAsync: Decoding Error")
            #endif
            throw LogRequestError.decoding
        }
        
        return convertToCourseEntity(responseData)
    }
    
    // MARK: DTO를 Entity로 변환 -> 추후 수정예정
    private func convertToCourseEntity(_ responseData: FetchConstellationDTO) -> [CourseEntity] {
        
        var courses = [CourseEntity]()
        
        responseData.courses.forEach { course in
            var places = [PlaceEntity]()
            course.places.forEach { placeElement in
                let place = PlaceEntity(
                    id: placeElement.place.placeId,
                    title: placeElement.place.name,
                    category: "",
                    address: "",
                    coordinate: CLLocationCoordinate2D(latitude: placeElement.place.coordinate.latitude, longitude: placeElement.place.coordinate.longitude),
                    memo: placeElement.memo
                )
                places.append(place)
            }
            
            let tempCource = CourseEntity(
                id: course.courseId,
                courseTitle: course.title,
                date: course.date,
                isLike: course.liked,
                places: places
            )
            courses.append(tempCource)
        }
        return courses
    }
}
