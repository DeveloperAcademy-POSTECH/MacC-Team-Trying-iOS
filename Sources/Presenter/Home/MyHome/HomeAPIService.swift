//
//  HomeAPIService.swift
//  MatStar
//
//  Created by uiskim on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum HomeApiError: Error {
    case urlResponse
    case response
}

let fetchUserUrl = "http://15.165.72.196:3059/users/me"
//let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjdkNTk4YWFmLTAwNmQtNDZlYy05ODZiLWFjMmQzN2U1NjdkYiIsImF1dGgiOiJVU0VSIn0.Pa8oQyIVeua1HzIGuBIYwFU-TsHV7t6POhrZrI84TRHyzCpw-ELKTbejqdFSg1Jknzt8snDZhV10-MjyuKR_jw"
let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImRmMTg4ZTllLTg1ODItNGI2ZC1hM2NmLWEzNTNmY2FkMzE5NSIsImF1dGgiOiJVU0VSIn0.iemX4cOign5PyhkaixHK3GEDP5X6ABuWSt_ar4HzMEOhEX888SCauHYla_lRMgZTeQnmOAa8oqpAiuvcytzqdg"

let courseToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjU4MzI4NDU2LWRjNDAtNDNmOC1hZDkwLWMxMTMwYzA3NDNjMSIsImF1dGgiOiJVU0VSIn0.Q0cHg5ozXMbGxxZYjh4iSkeDTe86gxkNV13-kW6cpuHOAarUhntMdTU-SOfqA0j6c-AQ04Nb1F7_F57MMBlgmg"

class HomeAPIService {
    
    static func fetchUserAsync(accessToken: String) async throws -> Data {
        guard let url = URL(string: fetchUserUrl) else {
            throw HomeApiError.urlResponse
        }
        var request = URLRequest(url: url)
        request.setValue(accessToken, forHTTPHeaderField: "accessToken")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HomeApiError.response
        }
        return data
    }
    
    static func fetchUserCourseAsync(planetId: Int?) async throws -> Data {
        guard let planetId = planetId else {
            throw HomeApiError.urlResponse
        }
        guard let url = URL(string: "http://15.165.72.196:3059/planets/\(planetId)/courses") else {
            throw HomeApiError.urlResponse
        }
        var request = URLRequest(url: url)
        request.setValue(token, forHTTPHeaderField: "accessToken")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HomeApiError.response
        }
        return data
    }
    
//    static func fetchUser(onComplete: @escaping (Result<Data, Error>) -> Void) {
//        var request = URLRequest(url: URL(string: fetchUserUrl)!)
//        request.setValue(token, forHTTPHeaderField: "accessToken")
//        URLSession.shared.dataTask(with: request) { data, res, err in
//            if let err = err {
//                onComplete(.failure(err))
//                return
//            }
//
//            guard let data = data else {
//                let httpResponse = res as? HTTPURLResponse
//                onComplete(.failure(NSError(domain: "no data", code: httpResponse!.statusCode, userInfo: nil)))
//                return
//            }
//            onComplete(.success(data))
//        }.resume()
//    }
}
