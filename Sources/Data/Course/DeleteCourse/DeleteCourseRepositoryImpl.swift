//
//  DeleteCourseRepositoryImpl.swift
//  ComeIt
//
//  Created by κΉμΉμ°½ on 2022/11/19.
//  Copyright Β© 2022 Try-ing. All rights reserved.
//

import Foundation

final class DeleteCourseRepositoryImpl: DeleteCourseRepository {
    func deleteCourse(_ courseId: Int) async throws {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        
        let urlString = "\(APIManager.baseURL)/courses/\(courseId)"
        
        guard let url = URL(string: urlString) else { throw NetworkingError.urlError }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard statusCode == 200 else {
            #if DEBUG
            print("π₯statusCode : \(statusCode)")
            let debug = try JSONDecoder().decode(PodingError.self, from: data)
            print("π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯")
            print("id         : \(debug.id)")
            print("code       : \(debug.code)")
            print("message    : \(debug.message)")
            print("π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯π₯")
            #endif
            
            throw try self.judgeErrorStatus(by: statusCode)
        }
        #if DEBUG
        print("πππππ API ν΅μ  μ±κ³΅ πππππ")
        #endif
    }
}

// MARK: - Helper
extension DeleteCourseRepositoryImpl {
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
