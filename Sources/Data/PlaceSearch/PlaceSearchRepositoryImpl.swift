//
//  PlaceSearchRepositoryImpl.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/15.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import CoreLocation
import Foundation

final class PlaceSearchRepositoryImpl: PlaceSearchRepository {
    /*
    func getAddressUsingKakao(coordinate: CLLocationCoordinate2D) async throws -> String {
        var urlComponents = URLComponents(string: "https://dapi.kakao.com/v2/local/geo/coord2address.json")
        let latitudeQueryItem = URLQueryItem(name: "x", value: String(coordinate.latitude))
        let longitudeQueryItem = URLQueryItem(name: "y", value: String(coordinate.longitude))
        let inputCoordinatorQueryItem = URLQueryItem(name: "input_coord", value: "WGS84")
        
        urlComponents?.queryItems?.append(latitudeQueryItem)
        urlComponents?.queryItems?.append(longitudeQueryItem)
        urlComponents?.queryItems?.append(inputCoordinatorQueryItem)
        
        guard let url = urlComponents?.url else { throw NetworkingError.urlError }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
        request.setValue("KakaoAK fa0c6c8d186949d9d856d225a906fdba", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidServerResponse
        }
        
        let networkResult = try self.judgeStatus(by: httpResponse.statusCode, data, type: KakaoGetAddressDTO.self)
        
        return try self.convertToAddress(networkResult)
    }
    */
    
    func searchPlaceUsingKakao(query: String, coordinate: CLLocationCoordinate2D) async throws -> [Place] {
        var urlComponents = URLComponents(string: "https://dapi.kakao.com/v2/local/search/keyword.json")
        
        let queryItem = URLQueryItem(name: "query", value: "\(query)")
        let longitudeQueryItem = URLQueryItem(name: "x", value: "\(String(coordinate.longitude))")
        let latitudeQueryItem = URLQueryItem(name: "y", value: "\(String(coordinate.latitude))")
        
        urlComponents?.queryItems = [
            queryItem,
            longitudeQueryItem,
            latitudeQueryItem
        ]
        
        guard let urlString = urlComponents?.string,
              let url = URL(string: urlString) else { throw NetworkingError.urlError }
            
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.setValue("application/json;charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.setValue("KakaoAK fa0c6c8d186949d9d856d225a906fdba", forHTTPHeaderField: "Authorization")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkingError.invalidServerResponse
        }
        let dto = try self.judgeStatus(by: httpResponse.statusCode, data, type: KakaoPlaceSearchDTO.self)
        
        return try self.convertToPlace(dto)
    }
}

// MARK: - Helper
extension PlaceSearchRepositoryImpl {
    private func judgeStatus<T: Decodable>(by statusCode: Int, _ data: Data, type: T.Type) throws -> T {
        switch statusCode {
        case 200:
            return try decodeData(from: data, to: type)
        case 400..<500:
            throw NetworkingError.requestError(statusCode)
        case 500:
            throw NetworkingError.serverError(statusCode)
        default:
            throw NetworkingError.networkFailError(statusCode)
        }
    }
    
    private func decodeData<T: Decodable>(from data: Data, to type: T.Type) throws -> T {
        guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
            throw NetworkingError.decodeError(toType: T.self)
        }
        
        return decodedData
    }
    
    /*
    private func convertToAddress(_ dto: KakaoGetAddressDTO) throws -> String {
        if dto.meta.totalCount == 0 {
            throw NetworkingError.PlaceSearchError.noAddress
        } else {
            return dto.documents[0].roadAddress.addressName
        }
    }
    */
    
    private func convertToPlace(_ dto: KakaoPlaceSearchDTO) throws -> [Place] {
        var places = [Place]()
        
        dto.documents.forEach { document in
            let address = document.roadAddressName.isEmpty ? document.addressName : document.roadAddressName
            places.append(
                Place(
                    id: Int(document.id)!,
                    title: document.placeName,
                    category: document.categoryGroupName,
                    address: address,
                    location: CLLocationCoordinate2D(
                        latitude: Double(document.longitude)!,
                        longitude: Double(document.latitude)!
                    )
                )
            )
        }
        
        return places
    }
}
