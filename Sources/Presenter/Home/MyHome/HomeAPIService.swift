//
//  LogAPIService.swift
//  MatStar
//
//  Created by uiskim on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

protocol FetchNoCourse: AnyObject {
    func setMakeCoureButton()
}

enum HomeApiError: Error {
    case urlResponse
    case response
}

enum TokenType {
    case hasMate
    case noMate
}

private let fetchUserUrl = "https://comeit.site/users"

//private let token = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2MmZlMTkyYS0yYWEzLTQ0ZGQtOWZhNS00MzhkY2FjZWU5YTAiLCJhdXRoIjoiVVNFUiJ9.XanwnrThXnsf5J-PzdbmDpDrTJ_dr3upvz6eL4OP4yUUZlYHY0-XJne5v03mGBx24ylGJAO9aa1i8LNVn0F5Ig"
//
//private let mateToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2MjYyMTA0MS01NTI2LTRjZjgtOGJiOC0xMzdlODhmMDExYWEiLCJhdXRoIjoiVVNFUiJ9._hKs0Sr0JQDKF_-2XjubIp3OTHwwR6Tme4TgZ6PjGgE23oi_gPj2eglZP9w4IVaT7uyk2eYucbdL4zKXVQ9TuQ"
//
//private let rangeToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI2MjYyMTA0MS01NTI2LTRjZjgtOGJiOC0xMzdlODhmMDExYWEiLCJhdXRoIjoiVVNFUiJ9._hKs0Sr0JQDKF_-2XjubIp3OTHwwR6Tme4TgZ6PjGgE23oi_gPj2eglZP9w4IVaT7uyk2eYucbdL4zKXVQ9TuQ"
//
//let testToken = "Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiIyNTg4MzkwMC05MzIxLTQ0NDEtOTRjMy1lZDg0ZWMyM2Q5ZjQiLCJhdXRoIjoiVVNFUiJ9.y7Mh3zL4i9UfZ8RmC_03q_sPgGwOiU5t367wtv-Jm1tW4GJRIUNHfZwzeLorx21koP1okhUyTRwrBfimUEnfqQ"

class HomeAPIService {
    
    var delegate: FetchNoCourse?
    
    static func fetchUserAsync() async throws -> Data {
        
        guard let url = URL(string: fetchUserUrl) else {
            print("user url error")
            throw HomeApiError.urlResponse
        }
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: "accessToken")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            print("api response error")
            throw HomeApiError.response
        }
        return data
    }
    
    static func fetchDateList(dateRange: [String]) async throws -> Data {
        let dateRangeFetchUrl = "https://comeit.site/courses/dates?start=\(dateRange[0])&end=\(dateRange[1])"
        guard let url = URL(string: dateRangeFetchUrl) else {
            throw HomeApiError.urlResponse
        }
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: "accessToken")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HomeApiError.response
        }
        return data
    }
    
    static func fetchCourseList(selectedDate: String) async throws -> Data {
        let selectedDateCourseFetchUrl = "https://comeit.site/courses/dates/\(selectedDate)"
        guard let url = URL(string: selectedDateCourseFetchUrl) else {
            throw HomeApiError.urlResponse
        }
        var request = URLRequest(url: url)
        request.setValue(UserDefaults.standard.string(forKey: "accessToken"), forHTTPHeaderField: "accessToken")
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw HomeApiError.response
        }
        return data
    }
}
