//
//  ContentView.swift
//  HelloLocalNotifications
//
//  Created by James Lea on 5/31/23.
//

import SwiftUI
import AVFoundation
import UserNotifications

enum NotificationAction: String {
    case dismiss
    case reminder
}

enum NotificationCategory: String {
    case general
}

class NotificationDelegate: NSObject, UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let content = notification.request.content
        
        if UIApplication.shared.applicationState == .background || UIApplication.shared.isProtectedDataAvailable == false {
            // Check if the app is in the background or the device is locked
            
        }
        
        completionHandler([.banner, .sound, .badge])
    }

}

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Schedule Notification") {
                // Play the sound when the button is pressed
                //                playSound(key: "piano-bell")
                
                let center = UNUserNotificationCenter.current()
                
                // Create content
                let content = UNMutableNotificationContent()
                let soundName = UNNotificationSoundName("sound.mp3")
                let sound = UNNotificationSound(named: soundName)
                content.title = "Hot Coffee"
                content.body = "Your delicious coffee is ready!"
                content.categoryIdentifier = NotificationCategory.general.rawValue
                content.sound = sound
                
                // Create trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                
                // Create request
                let request = UNNotificationRequest(identifier: "goy", content: content, trigger: trigger)
                
                // Define actions
                let dismissAction = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss", options: [])
                
                let reminderAction = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
                
                let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismissAction, reminderAction], intentIdentifiers: [], options: [])
                
                // Set notification categories
                center.setNotificationCategories([generalCategory])
                
                // Add request to notification center
                center.add(request) { error in
                    if let error = error {
                        print(error)
                    }
                }
                
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
