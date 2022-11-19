//
//  KakaoGetAddressDTO.swift
//  ComeIt
//
//  Created by 김승창 on 2022/11/17.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct KakaoGetAddressDTO: Decodable {
    let meta: Meta
    let documents: [Document]
    
    struct Meta: Decodable {
        let totalCount: Int
        
        enum CodingKeys: String, CodingKey {
            case totalCount = "total_count"
        }
    }
    
    struct Document: Decodable {
        let address: Address
        let roadAddress: RoadAddress
        
        enum CodingKeys: String, CodingKey {
            case address
            case roadAddress = "road_address"
        }
    }
    
    struct Address: Decodable {
        let addressName: String
        let regionFirstDepthName: String
        let regionTwoDepthName: String
        let regionThreeDepthName: String
        let isMountain: String
        let mainAddress: String
        let subAddress: String
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case regionFirstDepthName = "region_1depth_name"
            case regionTwoDepthName = "region_2depth_name"
            case regionThreeDepthName = "region_3depth_name"
            case isMountain = "mountain_yn"
            case mainAddress = "main_address_no"
            case subAddress = "sub_address_no"
        }
    }
    
    struct RoadAddress: Decodable {
        let addressName: String
        let regionFirstDepthName: String
        let regionTwoDepthName: String
        let regionThreeDepthName: String
        let roadName: String
        let isUnderground: String
        let mainBuildingNo: String
        let subBuildingNo: String
        let buildingName: String
        let zoneNo: String
        
        enum CodingKeys: String, CodingKey {
            case addressName = "address_name"
            case regionFirstDepthName = "region_1depth_name"
            case regionTwoDepthName = "region_2depth_name"
            case regionThreeDepthName = "region_3depth_name"
            case roadName = "road_name"
            case isUnderground = "underground_yn"
            case mainBuildingNo = "main_building_no"
            case subBuildingNo = "sub_building_no"
            case buildingName = "building_name"
            case zoneNo = "zone_no"
        }
    }
}
