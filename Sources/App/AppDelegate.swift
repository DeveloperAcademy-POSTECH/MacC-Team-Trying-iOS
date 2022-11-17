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

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForRemoteNotifications()
        
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

// MARK: - Push Notifications
extension AppDelegate: UNUserNotificationCenterDelegate {
    private func registerForRemoteNotifications() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
        
        let notificationCenter = UNUserNotificationCenter.current()
        notificationCenter.delegate = self
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        notificationCenter.requestAuthorization(options: options) { granted, error in
            guard granted else { return }
            
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 앱이 foreground 상태일 때 push가 온 경우
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse) async {
        // push를 탭한 경우
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰 등록 성공 시
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        Messaging.messaging().apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 디바이스 토큰 등록 실패 시
        print("Failed to register for notifications: \(error.localizedDescription)")
    }
}

// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        // TODO: 로그인 시 FCM Token을 서버에 넘겨주세요. (FCM 토큰은 앱이 지웠다가 다시 설치하면 토큰값이 바뀝니다.)
        print("✨FCM Token : \(fcmToken)")
    }
}
