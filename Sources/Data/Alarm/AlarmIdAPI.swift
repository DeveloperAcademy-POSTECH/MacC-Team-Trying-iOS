//
//  AlarmIdAPI.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/20.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine
import CancelBag

class AlarmIdAPI {

    private let cancelBag = CancelBag()
    
    //TODO: token 수정

    private var token = UserDefaults().string(forKey: "accessToken") ?? ""
    
    private let host = APIManager.baseURL
    
    func getCourseWith(_ type: AlarmIdApiType, id: String) async throws -> AlarmCourseIdDTO {
        let urlStr = encodeUrl(string: addStringParameter(type: type, id: id))
        let url = URL(string: urlStr)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(token)", forHTTPHeaderField: "accessToken")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let response = try decoder.decode(AlarmCourseIdDTO.self, from: data)
        return response
        
    }
    
    func getReviewWith(_ type: AlarmIdApiType, id: String) async throws -> AlarmReviewIdDTO {
        let urlStr = encodeUrl(string: addStringParameter(type: type, id: id))
        let url = URL(string: urlStr)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(token)", forHTTPHeaderField: "accessToken")
        
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let response = try decoder.decode(AlarmReviewIdDTO.self, from: data)
        return response
        
    }
    
}

extension AlarmIdAPI {
    private func addStringParameter(type: AlarmIdApiType, id: String) -> String {
        var urlString = host
        switch type {
        case .course:
            urlString += "courses/\(id)"
        case .review:
            urlString += "reviews/\(id)"
        }
        return urlString
    }
    
    private func encodeUrl(string: String) -> String {
        return string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
}

enum AlarmIdApiType {
    case course
    case review
}
