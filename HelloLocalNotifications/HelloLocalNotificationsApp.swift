//
//  HelloLocalNotificationsApp.swift
//  HelloLocalNotifications
//
//  Created by James Lea on 5/31/23.
//

import SwiftUI

@main
struct HelloLocalNotificationsApp: App {
    
    private var delegate: NotificationDelegate = NotificationDelegate()
    
    init() {
        let center = UNUserNotificationCenter.current()
        center.delegate = delegate
        center.requestAuthorization(options: [.alert, .sound, .badge]) { result, error in
            if let error = error {
                print(error)
            }
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
