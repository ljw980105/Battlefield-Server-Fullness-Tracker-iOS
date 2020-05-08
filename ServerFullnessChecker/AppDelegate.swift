//
//  AppDelegate.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 4/30/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import UIKit
import Combine

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var disposeBag: [AnyCancellable] = []


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        NotificationHandler
            .requestPermissions()
            .flatMap { NotificationHandler.getNotificationSettings() }
            .sink(receiveCompletion: { _ in }, receiveValue: { settings in
                print(settings)
                DispatchQueue.main.async {
                    application.registerForRemoteNotifications()
                }
            })
            .store(in: &disposeBag)
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    // MARK: - Push Notifications
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        ServerTrackerAPI
            .IdExistsForDeviceID(token)
            .filter { !$0.success }
            .flatMap { _ in ServerTrackerAPI.addDeviceID(token) }
            .sink(receiveCompletion: { _ in }) { resp in
                print(resp.success)
            }
            .store(in: &disposeBag)
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }

}

