//
//  UserResponseModel.swift
//  ComeIt
//
//  Created by Jaeyong Lee on 2022/11/18.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct UserResponseModel: Decodable {
    let me: Mate
    let mate: Mate?
    let planet: Planet?
    let hasNotification: Bool
    let activities: Activity
    let socialAccount: Bool

    struct Mate: Decodable {
        let name: String
        let email: String?
    }

    struct Planet: Decodable {
        let name: String
        let meetDate: String
        let dday: Int
        let image: String
        let code: String?
    }
    
    struct Activity: Decodable {
        let courseCount: Int
        let likedCount: Int
    }
}
