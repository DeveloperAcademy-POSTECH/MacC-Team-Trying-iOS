//
//  NetworkingError.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum NetworkingError: Error {
    case urlError
    case encodeError
    case decodeError(toType: Decodable.Type)
    case requestError(_ statusCode: Int)
    case serverError(_ statusCode: Int)
    case networkFailError(_ statusCode: Int)
    case invalidServerResponse
    
    enum PlaceSearchError: Error {
        case noAddress
    }
}

struct PodingError: Decodable {
    let id: String
    let code: String
    let message: String
}
