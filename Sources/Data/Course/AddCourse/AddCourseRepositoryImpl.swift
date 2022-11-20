//
//  AddCourseRepositoryImpl.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

final class AddCourseRepositoryImpl: AddCourseRepository {
    func addCourse(courseRequestDTO: CourseRequestDTO) async throws -> Int {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        let urlString = "https://comeit.site/courses"
        
        guard let url = URL(string: urlString) else { throw NetworkingError.urlError }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        guard let uploadData = try? JSONEncoder().encode(self.convertToRequest(courseRequestDTO)) else { throw NetworkingError.encodeError }
        
        let (data, response) = try await URLSession.shared.upload(for: request, from: uploadData)
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard statusCode == 200 else {
            print("🔥statusCode : \(statusCode)")
            let debug = try JSONDecoder().decode(PodingError.self, from: data)
            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
            print("id         : \(debug.id)")
            print("code       : \(debug.code)")
            print("message    : \(debug.message)")
            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
            
            throw try self.judgeErrorStatus(by: statusCode)
        }
        print("🎉🎉🎉🎉🎉 API 통신 성공 🎉🎉🎉🎉🎉")
        
        guard let result = try? JSONDecoder().decode(AddCourseResponse.self, from: data) else { throw NetworkingError.decodeError(toType: AddCourseResponse.self) }
        
        return result.courseId
    }
}

// MARK: - Helper
extension AddCourseRepositoryImpl {
    private func convertToRequest(_ courseRequestDTO: CourseRequestDTO) -> AddCourseRequest {
        var places = [AddCourseRequest.Place]()
        
        courseRequestDTO.places.forEach { place in
            let placeElement = AddCourseRequest.Place.PlaceElement(
                identifier: place.id,
                name: place.title,
                category: place.category,
                address: place.address,
                latitude: place.location.latitude,
                longitude: place.location.longitude
            )
            
            let element = AddCourseRequest.Place(
                place: placeElement,
                memo: place.memo
            )
            
            places.append(element)
        }
        
        return AddCourseRequest(
            title: courseRequestDTO.title,
            date: courseRequestDTO.date,
            places: places
        )
    }
    
    private func judgeErrorStatus(by statusCode: Int) throws -> Error {
        switch statusCode {
        case 400..<500:
            throw NetworkingError.requestError(statusCode)
        case 500:
            throw NetworkingError.serverError(statusCode)
        default:
            throw NetworkingError.networkFailError(statusCode)
        }
    }
}
