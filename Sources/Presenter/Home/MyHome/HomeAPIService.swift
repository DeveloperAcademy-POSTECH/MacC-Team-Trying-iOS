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
