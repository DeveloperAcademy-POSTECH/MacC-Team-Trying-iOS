//
//  NetworkError.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol DomainError {
    var message: String? { get }
}

struct BaseError: DomainError {
    var message: String?
}

struct BadServerResponse {
    let statusCode: Int
    let body: DomainError
}

enum NetworkError: Error {
    case invalidResponse
    case invalidURL(url: String?)
    case badServerResponse(BadServerResponse)
}
