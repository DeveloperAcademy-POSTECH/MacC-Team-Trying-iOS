//
//  FetchReviewRepositoryImpl.swift
//  ComeIt
//
//  Created by YeongJin Jeong on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum ReviewRequestError: Error {
    case urlResponse
    case response
    case decoding
}

final class FetchReviewRepositoryImpl {
        private let token = UserDefaults.standard.string(forKey: "accessToken")
}

extension FetchReviewRepositoryImpl: FetchReviewRepository {
    func fetchReviewAsync(courseId: Int) async throws -> [ReviewEntity] {
        let url = "\(APIManager.baseURL)/courses/\(courseId)/review"
        
        guard let fetchReviewUrl = URL(string: url) else {
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("fetchReviewAsync: URL Error occured")
            throw ReviewRequestError.urlResponse
        }
        
        var request = URLRequest(url: fetchReviewUrl)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            #if DEBUG
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("fetchReviewAsync: API Response Error")
            print(response)
            #endif
            throw ReviewRequestError.response
        }
        
        guard let responseData = try? JSONDecoder().decode(FetchReviewDTO.self, from: data) else {
            #if DEBUG
            print("⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️⭐️")
            print("fetchLogAsync: Decoding Error")
            #endif
            throw ReviewRequestError.decoding
        }
        return convertToReviewEntity(responseData)
    }
    
    private func convertToReviewEntity(_ responseData: FetchReviewDTO) -> [ReviewEntity] {
        
        var reviews = [ReviewEntity]()
        let emptyReview = ReviewEntity(name: "", imagesURL: [], content: "")
        
        if let myReview = responseData.myReview {
            let myReviewEntity = ReviewEntity(
                name: myReview.writerName,
                imagesURL: myReview.images,
                content: myReview.content
            )
            reviews.append(myReviewEntity)
        } else {
            reviews.append(emptyReview)
        }
        
        if let mateReview = responseData.mateReview {
            let mateReviewEntity = ReviewEntity(
                name: mateReview.writerName,
                imagesURL: mateReview.images,
                content: mateReview.content
            )
            reviews.append(mateReviewEntity)
        } else {
            reviews.append(emptyReview)
        }
        return reviews
    }
}
