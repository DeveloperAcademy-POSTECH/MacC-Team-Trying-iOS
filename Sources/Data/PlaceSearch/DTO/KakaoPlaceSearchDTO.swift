//
//  KakaoPlaceSearchDTO.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct KakaoPlaceSearchDTO: Decodable {
    let meta: Meta
    let documents: [Document]
    
    struct Meta: Decodable {
        let sameName: SameName
        let pageableCount: Int
        let totalCount: Int
        let isEnd: Bool
        
        enum CodingKeys: String, CodingKey {
            case sameName = "same_name"
            case pageableCount = "pageable_count"
            case totalCount = "total_count"
            case isEnd = "is_end"
        }
    }
    
    struct SameName: Decodable {
        let region: [String]
        let keyword: String
        let selectedRegion: String
        
        enum CodingKeys: String, CodingKey {
            case region
            case keyword
            case selectedRegion = "selected_region"
        }
    }
    
    struct Document: Decodable {
        let id: String
        let placeName: String
        let categoryName: String
        let categoryGroupCode: String
        let categoryGroupName: String
        let phone: String
        let addressName: String
        let roadAddressName: String
        let latitude: String
        let longitude: String
        let placeURL: String
        let distance: String
        
        enum CodingKeys: String, CodingKey {
            case id
            case placeName = "place_name"
            case categoryName = "category_name"
            case categoryGroupCode = "category_group_code"
            case categoryGroupName = "category_group_name"
            case phone
            case addressName = "address_name"
            case roadAddressName = "road_address_name"
            case latitude = "x"
            case longitude = "y"
            case placeURL = "place_url"
            case distance
        }
    }
}
