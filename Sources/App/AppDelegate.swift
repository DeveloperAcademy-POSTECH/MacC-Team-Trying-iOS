//
//  AppDelegate.swift
//  MatStar
//
//  Created by 김승창 on 2022/10/11.
//  Copyright © 2022 Try-ing. All rights reserved.
//

import UIKit

import Firebase
import KakaoSDKAuth
import KakaoSDKCommon

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    var coordinator: AppCoordinator?
    let alarmAPI: AlarmAPI = AlarmAPI()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if let options = launchOptions {
                if let remoteNotification = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                // remoteNotification에 푸시에서 받은 내용이 들어 있음
                    print("!!앱이 실행되지 않은 상태에서 푸쉬를 통한 이동, 데이터:", remoteNotification)
                }
            }
        
        self.registerForRemoteNotifications()
        UserDefaults.standard.set("Bearer eyJhbGciOiJIUzUxMiJ9.eyJzdWIiOiI5N2Q3MmZjNi1jMDY3LTQ0M2EtYWYxNy0wNDc4MWZhZjdiZjQiLCJhdXRoIjoiVVNFUiJ9.8BhkTffQ5jByS8uL0D9RRGpUpahf70t9qZNSnRcfzEHrW4X2uxcaKfgzco39iQW3Puveb4ol2gl1-mLwkXxh8g", forKey: "accessToken")
        Font.registerFonts()
        KakaoSDK.initSDK(appKey: "041c741d45744f54da6ed10e0f946672")
        self.window = UIWindow(frame: UIScreen.main.bounds)

        coordinator = AppCoordinator(window: window!)
        coordinator?.start()

        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        if (AuthApi.isKakaoTalkLoginUrl(url)) {
            return AuthController.handleOpenUrl(url: url)
        }

        return false
    }
}

class FpnCenter {
    static let messaging = Messaging.messaging()
    static let notificationCenter = UNUserNotificationCenter.current()
    public init() { }
}
// MARK: - Push Notifications

extension AppDelegate: UNUserNotificationCenterDelegate {
    private func registerForRemoteNotifications() {
        FirebaseApp.configure()
        
        FpnCenter.messaging.delegate = self
        FpnCenter.notificationCenter.delegate = self
        FpnCenter.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                UserDefaults().set(false, forKey: "alarmPermssion")
                return
            }
            DispatchQueue.main.async { [weak self] in
                UserDefaults().set(true, forKey: "alarmPermssion")
                self?.alarmAPI.toggleAlarmPermission(type: .togglePermission, isPermission: true)
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        completionHandler([.badge, .banner, .list])
        print("!!", userInfo)
        // 앱이 foreground 상태일 때 push가 온 경우
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        let userInfo = response.notification.request.content.userInfo
        let application = UIApplication.shared
        
        guard let target = userInfo["target"] as? String,
              let targetId = userInfo["targetId"] as? String,
              let coordinator = coordinator,
              let mainCoordinator = coordinator.mainCoordinator else { return }
        if target == "COURSE" {
            mainCoordinator.tabBarController.selectedIndex = 0
            mainCoordinator.homeCoordinator?.pushToAlarmViewController()

            // MARK: 🛑 추후 홈뷰로 이동할때 🛑
//            mainCoordinator.homeCoordinator?.navigationController?.popToRootViewController(animated: true)
//            NotificationCenter.default.post(name: Notification.Name("COURSE"), object: targetId)
            
        } else if target == "REVIEW" {
            mainCoordinator.tabBarController.selectedIndex = 2
            mainCoordinator.logCoordinator?.navigationController?.popToRootViewController(animated: true)
            NotificationCenter.default.post(name: Notification.Name("REVIEW"), object: targetId)
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰 등록 성공 시
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print(deviceToken, deviceTokenString)
        FpnCenter.messaging.apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 디바이스 토큰 등록 실패 시
        print("!!Failed to register for notifications: \(error.localizedDescription)")
    }
}
// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // TODO: 로그인 시 FCM Token을 서버에 넘겨주세요. (FCM 토큰은 앱이 지웠다가 다시 설치하면 토큰값이 바뀝니다.)
        print("✨FCM Token : \(fcmToken)")
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
}

