//
//  NetworkProvider.swift
//  MatStar
//
//  Created by Jaeyong Lee on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol NetworkProvider {
    associatedtype Target = TargetType
    func send<M: Decodable>(_ request: Target) async throws -> M
}

final class NetworkProviderImpl<T: TargetType>: NetworkProvider {

    private let session: URLSession

    init(session: URLSession = .shared) {
        self.session = session
    }

    func send<M: Decodable>(_ request: T) async throws -> M {
        try await withCheckedThrowingContinuation { continuation in
            do {
                let urlRequest = try RequestFactory(request: request).makeURLRequest()
                let task = session.dataTask(with: urlRequest) { data, response, error in
                    if let error = error as? URLError {
                        continuation.resume(with: .failure(error))
                        return
                    }
                    guard let data = data,
                          let httpResponse = response as? HTTPURLResponse,
                          (200..<400).contains(httpResponse.statusCode)
                    else {
                        print(response as? HTTPURLResponse)
                        continuation.resume(with: .failure(NetworkError.badServerResponse))
                        return
                    }
                    do {
                        let output = try JSONDecoder().decode(M.self, from: data)
                        continuation.resume(with: .success(output))
                    } catch {
                        continuation.resume(with: .failure(error))
                    }
                }
                task.resume()
            } catch {
                continuation.resume(with: .failure(error))
            }

        }
    }
}

private final class RequestFactory<T: TargetType> {
    let request: T
    private var urlComponents: URLComponents?

    init(request: T) {
        self.request = request
        if let url = URL(string: request.baseURL + request.path) {
            self.urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: true)
        }
    }

    func makeURLRequest() throws -> URLRequest {
        if request.query.isEmpty == false {
            urlComponents?.queryItems = request.query.map { URLQueryItem(name: $0.key, value: "\($0.value)") }
        }
        guard let url = urlComponents?.url else {
            throw NetworkError.invalidURL(url: request.path)
        }
        var urlRequest = URLRequest(url: url)
        if let body = request.body {
            let jsonEncoder = JSONEncoder()
            jsonEncoder.outputFormatting = .withoutEscapingSlashes
            let data = try jsonEncoder.encode(body)
            urlRequest.httpBody = data
        }

        request.headers?.forEach { header in
            urlRequest.setValue(header.value, forHTTPHeaderField: header.key)
        }
        urlRequest.addValue(request.contentType, forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = request.method.rawValue
        return urlRequest
    }
}

enum NetworkError: Error {
    case invalidURL(url: String?)
    case badServerResponse
}
