//
//  AlarmDTO.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct AlarmResponse: Codable {
    let notifications: [AlarmDTO]
}
struct AlarmDTO: Codable {
    
    let notificationID: Int
    let title: String
    let body: String
    let target: String?
    let targetID: Int?
    let createdDate: String
    let checked: Bool

    enum CodingKeys: String, CodingKey {
        case notificationID = "notificationId"
        case title, body, target
        case targetID = "targetId"
        case createdDate, checked
    }
}
