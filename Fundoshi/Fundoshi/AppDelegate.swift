//
//  AppDelegate.swift
//  Fundoshi
//
//  Created by ookamitai on 8/3/24.
//

import Foundation
import UserNotifications
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, UNUserNotificationCenterDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { (granted, error) in
            if !granted {
                print(error as Any)
            }
        }
    }
}
