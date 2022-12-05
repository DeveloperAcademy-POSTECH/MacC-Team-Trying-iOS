//
//  ExitAPIService.swift
//  ComeIt
//
//  Created by uiskim on 2022/11/19.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

enum ExitApiError: Error {
    case urlError
    case urlResponseError
}

private let exitPlanetUrl = "\(APIManager.baseURL)/planets"
private let membershipWithdrawalUrl = "\(APIManager.baseURL)/users"

final class ExitAPIService {
    static func exitPlanet() async throws {
        guard let url = URL(string: exitPlanetUrl) else {
            print("exit api url error")
            throw ExitApiError.urlError
        }
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: "accessToken")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("exit api response error")
            throw ExitApiError.urlResponseError
        }
        print("행성나가기 성공")
    }
    
    static func membershipWithdrawal() async throws {
        guard let url = URL(string: membershipWithdrawalUrl) else {
            print("withdrawal api url error")
            throw ExitApiError.urlError
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        request.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: "accessToken")
        let (_, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("withdrawal api response error")
            throw ExitApiError.urlResponseError
        }
        print("회원탈퇴 성공")
    }
}
