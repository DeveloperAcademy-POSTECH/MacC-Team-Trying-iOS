//
//  AlarmEntity.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/16.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation

struct AlarmEntity {
    
    init(
        type: AlarmType,
        id: Int,
        title: String,
        description: String,
        leftTimeString: String,
        target: String,
        targetId: Int,
        checked: Bool
    ) {
        self.type = type
        self.id = id
        self.title = title
        self.leftTimeString = leftTimeString
        self.description = description
        self.target = target
        self.targetId = targetId
        self.checked = checked
    }
    
    let type: AlarmType
    let id: Int
    var checked: Bool
    let title: String
    let description: String
    let target: String
    let targetId: Int
    let leftTimeString: String
    var iconImageString: String {
        switch type {
        case .new:
            return "alarmStar"
        case .tommorow:
            return "alarmCal"
        case .arrive:
            return "alarmHeart"
        }
    }
}

enum AlarmType {
    case new
    case tommorow
    case arrive
}
