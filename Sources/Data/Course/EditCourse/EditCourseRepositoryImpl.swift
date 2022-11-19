//
//  EditCourseRepositoryImpl.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class EditCourseRepositoryImpl: EditCourseRepository {
    func editCourse(_ editCourseDTO: CourseRequestDTO) async throws -> Int {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        
        let urlString = "https://comeit.site/courses/\(editCourseDTO.id!)"
        guard let url = URL(string: urlString) else { throw NetworkingError.urlError }
        
        guard let jsonData = try? JSONEncoder().encode(self.convertToRequest(editCourseDTO)) else {
            throw NetworkingError.encodeError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "accessToken")
        request.httpBody = jsonData
        
        let (data, response) = try await URLSession.shared.data(for: request)
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard try self.judgeStatus(by: statusCode) == true else { throw
            NetworkingError.invalidServerResponse
        }
        
        let networkResult = try self.decodeData(from: data, to: EditCourseResponse.self)
        return networkResult.courseId
    }
}

// MARK: - Helper
extension EditCourseRepositoryImpl {
        private func judgeStatus(by statusCode: Int) throws -> Bool {
            switch statusCode {
            case 200:
                return true
            case 400..<500:
                throw NetworkingError.requestError(statusCode)
            case 500:
                throw NetworkingError.serverError(statusCode)
            default:
                throw NetworkingError.networkFailError(statusCode)
            }
        }
    
    private func encodeData(from data: Data) throws -> Data {
        guard let encodedData = try? JSONEncoder().encode(data) else {
            throw NetworkingError.encodeError
        }
        
        return encodedData
    }
    
    private func decodeData<T: Decodable>(from data: Data, to type: T.Type) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkingError.decodeError(toType: T.self)
        }
        
        return decodedData
    }
    
    private func convertToRequest(_ courseRequestDTO: CourseRequestDTO) -> EditCourseRequest {
        var places = [EditCourseRequest.Place]()
        
        courseRequestDTO.places.forEach { place in
            let placeElement = EditCourseRequest.Place.PlaceElement(
                identifier: place.id,
                name: place.title,
                category: place.category,
                address: place.address,
                latitude: place.location.latitude,
                longitude: place.location.longitude
            )
            
            let element = EditCourseRequest.Place(
                place: placeElement,
                memo: place.memo
            )
            
            places.append(element)
        }
        
        return EditCourseRequest(
            title: courseRequestDTO.title,
            date: courseRequestDTO.date,
            places: places
        )
    }
}
