//
//  DeleteReviewRepositoryImpl.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

final class DeleteReviewRepositoryImpl: DeleteReviewRepository {
    func deleteReview(_ reviewId: Int) async throws {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        
        let urlString = "https://comeit.site/reviews\(reviewId)"
        
        guard let url = URL(string: urlString) else { throw NetworkingError.urlError }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (_ , response) = try await URLSession.shared.data(for: request)
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard try self.judgeStatus(by: statusCode) == true else { throw
            NetworkingError.invalidServerResponse
        }
    }
}

// MARK: - Helper
extension DeleteReviewRepositoryImpl {
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
}
