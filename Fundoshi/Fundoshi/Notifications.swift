//
//  Notifications.swift
//  Fundoshi
//
//  Created by ookamitai on 8/3/24.
//

import Foundation
import UserNotifications

func notify(msg: String) {
    let content = UNMutableNotificationContent()
    content.title = "Time's up"
    content.subtitle = msg
    content.sound = UNNotificationSound.default
    let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.5, repeats: false)
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    UNUserNotificationCenter.current().add(request)
}
