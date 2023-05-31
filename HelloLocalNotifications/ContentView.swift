//
//  ContentView.swift
//  HelloLocalNotifications
//
//  Created by James Lea on 5/31/23.
//

import SwiftUI

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
        completionHandler([.banner, .sound, .badge])
    }
    
}

struct ContentView: View {
    var body: some View {
        VStack {
            
            Button("Schedule Notification") {
                let center = UNUserNotificationCenter.current()
                
                //Create content
                let content = UNMutableNotificationContent()
                content.title = "Hot Coffee"
                content.body = "Your delicious coffee is ready!"
                content.categoryIdentifier = NotificationCategory.general.rawValue
                content.userInfo = ["customData": "Some Data"]
                
                if let url = Bundle.main.url(forResource: "coffee2", withExtension: "jpeg") {
                    if let attachment = try? UNNotificationAttachment(identifier: "image", url: url) {
                        content.attachments = [attachment]
                    }
                }
                
                //Create trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
                
                //Create request
                let request = UNNotificationRequest(identifier: "goy", content: content, trigger: trigger)
                
                //Define actions
                let dismissAction = UNNotificationAction(identifier: NotificationAction.dismiss.rawValue, title: "Dismiss", options: [])
                
                let reminderAction = UNNotificationAction(identifier: NotificationAction.reminder.rawValue, title: "Reminder", options: [])
                
                let generalCategory = UNNotificationCategory(identifier: NotificationCategory.general.rawValue, actions: [dismissAction, reminderAction], intentIdentifiers: [], options: [])
                
                //Set notification categories
                center.setNotificationCategories([generalCategory])
                
                //Add request to notification center
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
