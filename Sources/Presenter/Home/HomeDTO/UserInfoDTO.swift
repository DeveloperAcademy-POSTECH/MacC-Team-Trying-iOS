//
//  UserInfoDTO.swift
//  MatStar
//
//  Created by uiskim on 2022/10/25.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct DateList: Codable {
    let dates: [String]
}

struct UserInfoDTO: Codable {
    let me: Me
    let mate: Mate?
    let planet: Planet?
    let hasNotification, allowNotification: Bool
    let activities: Activities
    let socialAccount: Bool
    
    // MARK: - Activities
    struct Activities: Codable {
        let courseCount, likedCount: Int
    }

    // MARK: - Mate
    struct Mate: Codable {
        let name: String
    }

    // MARK: - Me
    struct Me: Codable {
        let name: String
        let email: String?
    }

    // MARK: - Planet
    struct Planet: Codable {
        let name, meetDate: String
        let dday: Int
        let image: String
        let hasBeenMateEntered: Bool
    }
}
