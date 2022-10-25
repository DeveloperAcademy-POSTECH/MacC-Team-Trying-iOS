//
//  HomeAPIService.swift
//  MatStar
//
//  Created by uiskim on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

let fetchUserUrl = "http://15.165.72.196:3059/users/me"
let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJpZCI6IjdkNTk4YWFmLTAwNmQtNDZlYy05ODZiLWFjMmQzN2U1NjdkYiIsImF1dGgiOiJVU0VSIn0.Pa8oQyIVeua1HzIGuBIYwFU-TsHV7t6POhrZrI84TRHyzCpw-ELKTbejqdFSg1Jknzt8snDZhV10-MjyuKR_jw"

class HomeAPIService {
    static func fetchUserAsync() async throws -> Data {
        var request = URLRequest(url: URL(string: fetchUserUrl)!)
        request.setValue(token, forHTTPHeaderField: "accessToken")
        do {
            let (data, response) = try await URLSession.shared.data(for: request)
            dump(response)
            return data
        } catch {
            print("오류")
            fatalError()
        }
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
