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
import Combine

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var cancelBag = Set<AnyCancellable>()
    var coordinator: AppCoordinator?
    let alarmAPI: AlarmAPI = AlarmAPI()
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        self.registerForRemoteNotifications()
        Font.registerFonts()
        KakaoSDK.initSDK(appKey: "9c2a1e0b53a641cb78b1dfb36f00793d")
        self.window = UIWindow(frame: UIScreen.main.bounds)

        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(moveToForeground), name: UIApplication.willEnterForegroundNotification, object: nil)
        
        coordinator = AppCoordinator(window: window!)
        
        coordinator?.presentSplashView()
        coordinator?.$isMainCoordinatorMade
            .sink(receiveCompletion: { _ in
        }, receiveValue: { bool in
            if bool {
                if let options = launchOptions {
                    if let remoteNotification = options[UIApplication.LaunchOptionsKey.remoteNotification] as? [AnyHashable: Any] {
                        self.goToAnotherTab(userInfo: remoteNotification)
                    }
                }
            }
        }).store(in: &cancelBag)
        
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
    
    @objc func moveToForeground() {
        let userService = UserService()
        Task {
            let userInformations = try await userService.getUserInformations()
            if let _ = userInformations.mate {
            } else {
                if UserDefaults.standard.bool(forKey: "hasMate") {
                    presentUserWarningViewController()
                }
            }
        }
    }
    
    private func registerForRemoteNotifications() {
        FirebaseApp.configure()
        
        FcmCenter.shared.messaging.delegate = self
        FcmCenter.shared.notificationCenter.delegate = self
        
        FcmCenter.shared.notificationCenter.requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            guard granted else {
                UserDefaults().set(false, forKey: "alarmPermission")
                return
            }
            UserDefaults().set(true, forKey: "alarmPermission")
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    private func presentUserWarningViewController() {
        let vc = UserWarningViewController(outgoingType: .exitPlanet)
        vc.navigationController?.navigationItem.setHidesBackButton(true, animated: true)
        coordinator?.mainCoordinator?.navigationController?.setViewControllers([vc], animated: false)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // 앱이 foreground 상태일 때 push가 온 경우
        let userInfo = notification.request.content.userInfo
        
        guard let target = userInfo["target"] as? String else {
            return
        }
        if target == "JOIN" {
            goToAnotherTab(userInfo: userInfo)
            return
        } else if target == "LEAVE" {
            presentUserWarningViewController()
        } else {
            completionHandler([.badge, .banner, .list])
            NotificationCenter.default.post(name: Notification.Name("NewAlarmHomeView"), object: nil)
        }
        
        completionHandler([.badge, .banner, .list])
        // 앱이 foreground 상태일 때 push가 온 경우
        NotificationCenter.default.post(name: Notification.Name("NewAlarmHomeView"), object: nil)
        
    }
    
    private func goToAnotherTab(userInfo: [AnyHashable: Any]) {
        let _ = UIApplication.shared
        guard let target = userInfo["target"] as? String,
              let targetId = userInfo["targetId"] as? String,
              let notificationIdString = userInfo["notificationId"] as? String,
              let notificationId = Int(notificationIdString),
              let coordinator = coordinator,
              let mainCoordinator = coordinator.mainCoordinator else {
            if let target = userInfo["target"] as? String,
               let coordinator = coordinator {
                if target == "JOIN" {
                    UserDefaults().set(true, forKey: "hasMate")
                    coordinator.start()
                    return
                } else {
                    presentUserWarningViewController()
                    return
                }
            } else {
                return
            }
        }
        
        if target == "COURSE" {
            Task {
                if try await alarmAPI.checkAlarm(type: .check, id: notificationId) {
                    mainCoordinator.tabBarController.selectedIndex = 0
                    mainCoordinator.homeCoordinator?.pushToAlarmViewController()
                }
            }
            
            // MARK: 🛑 추후 홈뷰로 이동할때 🛑
            // mainCoordinator.homeCoordinator?.navigationController?.popToRootViewController(animated: true)
            // NotificationCenter.default.post(name: Notification.Name("COURSE"), object: targetId)
            
        } else if target == "REVIEW" {
            Task {
                if try await alarmAPI.checkAlarm(type: .check, id: notificationId) {
                    mainCoordinator.moveToLogTab()
                    NotificationCenter.default.post(name: Notification.Name("REVIEW"), object: targetId)
                }
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        // 디바이스 토큰 등록 성공 시
        // let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        FcmCenter.shared.messaging.apnsToken = deviceToken
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        // 디바이스 토큰 등록 실패 시
    }
}
// MARK: - MessagingDelegate
extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        UserDefaults.standard.set(fcmToken, forKey: "fcmToken")
    }
}
