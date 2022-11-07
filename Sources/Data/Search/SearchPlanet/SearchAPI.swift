//
//  SearchAPI.swift
//  MatStar
//
//  Created by Hankyu Lee on 2022/10/27.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine
import CancelBag

class SearchAPI {
    
    private let cancelBag = CancelBag()
    //TODO: token 수정
    private let token = "eyJhbGciOiJIUzUxMiJ9.eyJpZCI6ImQxNjZmZGUzLTg3YWQtNDM0My05MmRlLTQ1Yzk2Yjc3ZmEzMSIsImF1dGgiOiJVU0VSIn0.BOcCdvpoXCaa8QoaaBYjt3Kqc2OGXvFrg64noNgYhWehvaeuCL6lTtRxAFfeT6xvzfWcJzE1IhrUmiT1Yy3ewA"
    
    private let host = "http://15.165.72.196:3059/"
    
    func courseLikeToggle(courseId: Int, isLike: Bool) {
        let urlString = encodeUrl(string: "http://15.165.72.196:3059/courses/\(courseId)/like")
        let url = URL(string: urlString)!
        var request = URLRequest(url:url)
        request.httpMethod = isLike ? "POST" : "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "accessToken")
        URLSession.shared.dataTaskPublisher(for: request)
            .assertNoFailure()
            .map(\.data)
            .sink { _ in }
            .cancel(with: cancelBag)
    }
    
    func planetFollowToggle(planetId: Int, isFollow: Bool) {
        let urlString = encodeUrl(string: "http://15.165.72.196:3059/planets/\(planetId)/follow")
        let url = URL(string: urlString)!
        var request = URLRequest(url:url)
        request.httpMethod = isFollow ? "POST" : "DELETE"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "accessToken")
        URLSession.shared.dataTaskPublisher(for: request)
            .assertNoFailure()
            .map(\.data)
            .sink { _ in }
            .cancel(with: cancelBag)
    }
    
    func getDataWithCombineSongs<T: Decodable>(searchType: SearchType, parameter: String, page: Int, isFirst: Bool) -> AnyPublisher<T, Error> {

        let urlStr = encodeUrl(string: addStringParameter(searchType: searchType, parameter: parameter, page: page, isFirst: isFirst))
        let url = URL(string: urlStr)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("Bearer \(token)", forHTTPHeaderField: "accessToken")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    private func addStringParameter(searchType: SearchType, parameter: String, page: Int, isFirst: Bool) -> String {
        
        switch searchType {
        case .course:
            return host + "courses?query=" + "\(parameter)&page=\(page)&size=\(isFirst ? 20 : 20)"
        case .planet:
            return host + "planets?query=" + "\(parameter)&page=\(page)&size=\(isFirst ? 20 : 20)"
        }
    }
    
    private func encodeUrl(string: String) -> String {
        return string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
}
