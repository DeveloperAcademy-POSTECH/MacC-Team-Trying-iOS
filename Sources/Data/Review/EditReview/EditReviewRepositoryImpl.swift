//
//  EditReviewRepositoryImpl.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import UIKit

final class EditReviewRepositoryImpl: EditReviewRepository {
    func editReview(reviewId: Int, content: String, images: [UIImage]) async throws {
        let token = UserDefaults.standard.string(forKey: "accessToken")
        
        let urlString = "\(APIManager.baseURL)/reviews/\(reviewId)"
        guard let url = URL(string: urlString) else { throw NetworkingError.urlError }
        
        let boundary = UUID().uuidString
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("multipart/form-data;charset=UTF-8; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        var data = Data()
        
        data.append("--\(boundary)\r\n".data(using: .utf8)!)
        data.append("Content-Disposition: form-data; name=content\r\n\r\n".data(using: .utf8)!)
        
        data.append("\(content)\r\n".data(using: .utf8)!)
        
        images.forEach { image in
            data.append("--\(boundary)\r\n".data(using: .utf8)!)
            data.append("Content-Disposition: form-data; name=images; filename=image.jpeg\r\n".data(using: .utf8)!)
            data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            data.append(image.jpegData(compressionQuality: 0.4)!)
            data.append("\r\n".data(using: .utf8)!)
        }
        data.append("--\(boundary)--".data(using: .utf8)!)
        
        let (responseData, response) = try await URLSession.shared.upload(for: request, from: data)
        
        let statusCode = (response as! HTTPURLResponse).statusCode
        guard statusCode == 200 else {
            #if DEBUG
            print("🔥statusCode : \(statusCode)")
            let debug = try JSONDecoder().decode(PodingError.self, from: responseData)
            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
            print("id         : \(debug.id)")
            print("code       : \(debug.code)")
            print("message    : \(debug.message)")
            print("🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥🔥")
            #endif
            
            throw try self.judgeErrorStatus(by: statusCode)
        }
        #if DEBUG
        print("🎉🎉🎉🎉🎉 API 통신 성공 🎉🎉🎉🎉🎉")
        #endif
    }
}

// MARK: - Helper
extension EditReviewRepositoryImpl {
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
