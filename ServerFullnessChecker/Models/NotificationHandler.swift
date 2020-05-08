//
//  NotificationHandler.swift
//  ServerFullnessChecker
//
//  Created by Jing Wei Li on 4/30/20.
//  Copyright © 2020 Jing Wei Li. All rights reserved.
//

import Foundation
import Combine
import NotificationCenter

class NotificationHandler {
    class func requestPermissions() -> Future<Void, Error> {
        return Future { promise in
            UNUserNotificationCenter.current()
                .requestAuthorization(options: [.alert, .sound, .badge])
                    { granted, error in
                        if let error = error {
                            promise(.failure(error))
                        } else if granted {
                            promise(.success(()))
                        }
                    }
        }
    }
    
    class func getNotificationSettings() -> Future<UNNotificationSettings, Error> {
        return Future { promise in
            UNUserNotificationCenter.current().getNotificationSettings { settings in
                promise(.success(settings))
            }
        }
    }

}
