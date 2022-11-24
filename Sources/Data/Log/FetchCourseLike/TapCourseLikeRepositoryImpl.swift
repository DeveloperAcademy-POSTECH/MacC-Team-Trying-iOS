//  TapCourseLikeRepositoryImpl.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/21.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum CourseLikeRequestError: Error {
    case urlResponse
    case response
    case decoding
}

final class TapCourseLikeRepositoryImpl {
    
    private let token = UserDefaults.standard.string(forKey: "accessToken")
}

extension TapCourseLikeRepositoryImpl: TapCourseLikeRepository {
    
    func setCourseLike(courseId: Int, isLike: Bool) async throws {
        
        let url = "\(APIManager.baseURL)/courses/\(courseId)/like"
        
        guard let setCourseLikeUrl = URL(string: url) else {
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("setCourseLike: URL Error occured")
            throw CourseLikeRequestError.urlResponse
        }
        
        var request = URLRequest(url: setCourseLikeUrl)
        
        switch isLike {
        case true:
            request.httpMethod = "DELETE"
        case false:
            request.httpMethod = "POST"
        }
        
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (_, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            #if DEBUG
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("setCourseLike: API Response Error")
            print(response)
            #endif
            throw CourseLikeRequestError.response
        }
    }
}
