//
//  PlaceSearchRepositoryImpl.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

final class PlaceSearchRepositoryImpl: PlaceSearchRepository {
    func placeSearch(name: String, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> PlaceSearchResponse {
        let page = 0
        let size = 10
        
        let urlString = "https://comeit.site/places?name=\(name)&latitude=\(latitude)&longitude=\(longitude)&page=\(page)&size=\(size)"
        let encodedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: encodedString)!
        
        let method = "GET"
        let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2OWY5MzU0Ny01YTk3LTQyZTEtOWE3My0xMzUwOWE5NjA2YTciLCJhdXRoIjoiVVNFUiJ9.znC6SpbwYq_ZEbK9kmj-IFPaQAnP-nHc4d3FgQDxe5DeWZZDWAAG-T-CAUAbBauCXezHRyVmXYL_ssUV8qfHYQ"
        
        var request = URLRequest(url: url)
        request.httpMethod = method
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidServerResponse
        }
        
        let networkResult = try self.judgeStatus(by: httpResponse.statusCode, data, type: PlaceSearchResponse.self)
        
        return networkResult
    }
    
    func placeSearch(distance: Double, latitude: CLLocationDegrees, longitude: CLLocationDegrees) async throws -> PlaceSearchResponse {
        let page = 0
        let size = 10
        let url = "https://comeit.site/places/position?distance=\(distance)&latitude=\(latitude)&longitude=\(longitude)&page=\(page)&size=\(size)"
        
        let method = "GET"
        let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI1ZDg5ZDExNS1jMjcxLTRjMTUtODM1Mi0xYjQxOWQ1NzdjNDIiLCJhdXRoIjoiVVNFUiJ9.8E8zx-xx1GhLXNER0Ubo_fxWYW_mclgQoB-xmgYTHcbpciZLKPk4qYD77GqrtropsPqkJeqiEzQqQMvYneLytg"
        
        var request = URLRequest(url: URL(string: url)!)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidServerResponse
        }
        
        let networkResult = try self.judgeStatus(by: httpResponse.statusCode, data, type: PlaceSearchResponse.self)
        
        return networkResult
    }
}

// MARK: - Helper
extension PlaceSearchRepositoryImpl {
    private func judgeStatus<T: Decodable>(by statusCode: Int, _ data: Data, type: T.Type) throws -> T {
        switch statusCode {
        case 200:
            return try decodeData(from: data, to: type)
        case 400..<500:
            throw NetworkingError.requestError(statusCode)
        case 500:
            throw NetworkingError.serverError(statusCode)
        default:
            throw NetworkingError.networkFailError(statusCode)
        }
    }
    
    private func decodeData<T: Decodable>(from data: Data, to type: T.Type) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkingError.decodeError(toType: T.self)
        }
        
        return decodedData
    }
}
