//
//  AppDelegate.swift
//  Fix Colors
//
//  Created by Nurassyl Nuridin on 4/11/17.
//  Copyright © 2017 Nurassyl Nuridin. All rights reserved.
//

import UIKit
import UserNotifications
import Firebase

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        FIRApp.configure()
        return true
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        scheduleNotification()
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        applicationWillEnterForeground(application)
    }

    func applicationWillTerminate(_ application: UIApplication) {
        applicationDidEnterBackground(application)
    }

    private func scheduleNotification() {
        let center = UNUserNotificationCenter.current()
        let texts = ["Hi! Come back to get more fun with Fix Colors.", "Hey! There are Fix Colors waiting for you."]
        let seconds: [TimeInterval] = [259200, 604800]
        
        let requestId = "FCrequestId"
        
        for i in 0..<2 {
            let content = UNMutableNotificationContent()
            content.body = texts[i]
            content.sound = UNNotificationSound.default()
            content.badge = NSNumber(value: i + 1)
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds[i], repeats: false)
            
            let request = UNNotificationRequest(identifier: "\(requestId)\(i)", content: content, trigger: trigger)
            center.add(request, withCompletionHandler: { error in
                if (error != nil) {
                    print(error!.localizedDescription)
                }
            })
        }
    }
}

