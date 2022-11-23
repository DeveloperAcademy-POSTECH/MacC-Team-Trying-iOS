//
//  FcmCenter.swift
//  ComeIt
//
//  Created by Hankyu Lee on 2022/11/22.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import Foundation
import Firebase

class FcmCenter {
    static let shared = FcmCenter()
    let messaging = Messaging.messaging()
    let notificationCenter = UNUserNotificationCenter.current()
    func toggleAlarmAPI() {
        AlarmAPI().toggleAlarmPermission(type: .togglePermission, isPermission: UserDefaults().bool(forKey: "alarmPermssion"))
    }
    private init() { }
}
