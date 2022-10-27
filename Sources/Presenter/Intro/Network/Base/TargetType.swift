//
//  TargetType.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum HTTPMethod: String, Encodable {
    case get = "GET"
    case post = "POST"
    case put = "PUT"
    case patch = "PATCH"
    case delete = "DELETE"
}

typealias HTTPHeader = [String: String]
typealias QueryItems = [String: AnyHashable]
protocol RequestBody: Encodable {}

struct EmptyResponseBody: Decodable {}

protocol TargetType {

    var baseURL: String { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var query: QueryItems? { get }
    var headers: HTTPHeader? { get }
    var body: RequestBody? { get }
}

extension TargetType {

    var contentType: String {
        "application/json"
    }

    private var token: String {
        guard let token = UserDefaults.standard.string(forKey: "accessToken") else {
            return ""
        }
        print(token)
        return token
    }
    var query: QueryItems? { nil }

    var headers: HTTPHeader? {
        ["accessToken": token]
    }

    var body: RequestBody? { nil }
}

extension TargetType {

    var baseURL: String { "http://15.165.72.196:3059" }
}
