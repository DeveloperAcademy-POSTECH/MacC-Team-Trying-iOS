//
//  DefaultConstellationRepository.swift
//  ComeItTests
//
//  Created by YeongJin Jeong on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

enum LogRequestError: Error {
    case urlResponse
    case response
}

final class FetchConstellationRepositoryImpl {
    
    let url = "https://comeit.site/courses/log?page=0&size=10"

    private let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2MjYyMTA0MS01NTI2LTRjZjgtOGJiOC0xMzdlODhmMDExYWEiLCJhdXRoIjoiVVNFUiJ9._hKs0Sr0JQDKF_-2XjubIp3OTHwwR6Tme4TgZ6PjGgE23oi_gPj2eglZP9w4IVaT7uyk2eYucbdL4zKXVQ9TuQ"
}

extension FetchConstellationRepositoryImpl: FetchConstellationRepository {
    
    func fetchLogAsyc() async throws -> Data {
        
        print("functioncall")
        
        guard let url = URL(string: url) else {
            print("################## LOG URL ERROR #######################")
            throw LogRequestError.urlResponse
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue(token, forHTTPHeaderField: "accessToken")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("api response error")
            print(response)
            throw LogRequestError.response
        }
//        print("😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊😊")
//        print("#####\(response)######")
//        do {
//            print(try JSONDecoder().decode(FetchConstellationDTO.self, from: data))
//        } catch {
//            print("err")
//        }
        
        return data
    }
}
