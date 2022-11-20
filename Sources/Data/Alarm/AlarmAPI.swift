//
//  AlarmAPI.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Combine
import CancelBag

class AlarmAPI {

    private let cancelBag = CancelBag()
    
    //TODO: token 수정

    private var token = UserDefaults().string(forKey: "accessToken") ?? ""
    
    private let host = "https://comeit.site/"
    
    func removeAllAlarms(type: AlarmApiType) async throws -> Bool {
        let urlStr = encodeUrl(string: addStringParameter(type: type))
        guard let url = URL(string: urlStr) else { return false }

        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.addValue("\(token)", forHTTPHeaderField: "accessToken")

        let (data, urlResponse) = try await URLSession.shared.data(for: request)
        guard let urlResponse = urlResponse as? HTTPURLResponse else { return false }
        if urlResponse.statusCode != 200 {
            return false
        }
        return true
        
//        URLSession.shared.dataTaskPublisher(for: request)
//            .map(\.data)
//            .eraseToAnyPublisher()
//            .assertNoFailure()
//            .sink(receiveValue: { _ in
//            })
//            .cancel(with: cancelBag)
    }
    
    func getAlarms(type: AlarmApiType) -> AnyPublisher<AlarmResponse, Error> {
        let urlStr = encodeUrl(string: addStringParameter(type: type, id: nil))
        let url = URL(string: urlStr)!

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("\(token)", forHTTPHeaderField: "accessToken")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .map(\.data)
            .decode(type: AlarmResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func checkAlarm(type: AlarmApiType, id: Int) {
        let urlStr = encodeUrl(string: addStringParameter(type: type, id: id))
        guard let url = URL(string: urlStr) else { return }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("\(token)", forHTTPHeaderField: "accessToken")

        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .print()
            .eraseToAnyPublisher()
            .assertNoFailure()
            .sink(receiveValue: { _ in
            })
            .cancel(with: cancelBag)
    }
    
    func toggleAlarmPermission(type: AlarmApiType, isPermission: Bool) {
        print("accessToken:", token)
        let urlStr = encodeUrl(string: addStringParameter(type: type))
        guard let url = URL(string: urlStr) else { return }

        var request = URLRequest(url: url)
        let json: [String: Any] = ["allow": isPermission]
        request.httpMethod = "PATCH"
        request.addValue("\(token)", forHTTPHeaderField: "accessToken")
        request.addValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONSerialization.data(withJSONObject: json)
        
        URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .print()
            .eraseToAnyPublisher()
            .assertNoFailure()
            .sink(receiveValue: { _ in
            })
            .cancel(with: cancelBag)
    }
    
}

extension AlarmAPI {
    private func addStringParameter(type: AlarmApiType, id: Int? = nil) -> String {
        var urlString = host
        switch type {
        case .fetch:
            urlString += "notifications"
        case .check:
            guard let id = id else { return "" }
            urlString += "notifications/\(id)"
        case .delete:
            urlString += "notifications"
        case .togglePermission:
            urlString += "users/notification"
        }
        return urlString
    }
    
    private func encodeUrl(string: String) -> String {
        return string.addingPercentEncoding( withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    
}

enum AlarmApiType {
    case fetch
    case check
    case delete
    case togglePermission
}
