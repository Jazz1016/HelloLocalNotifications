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
        
        if response.actionIdentifier == UNNotificationDefaultActionIdentifier {
            // The user tapped on the notification alert
            playSound()
        }
        
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        // Handle the notification when the app is in the foreground
        if notification.request.trigger is UNPushNotificationTrigger {
            // Remote notification
            print("Received remote notification in foreground.")
        } else {
            // Local notification
            playSound()
        }
        
        let options: UNNotificationPresentationOptions = [.banner, .sound, .badge]
        completionHandler(options)
    }
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "piano-bell", withExtension: "mp3") else {
            return
        }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation) // Add .notifyOthersOnDeactivation option
            
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
}

struct ContentView: View {
    var body: some View {
        VStack {
            Button("Schedule Notification") {
                // Play the sound when the button is pressed
                playSound()
                
                let center = UNUserNotificationCenter.current()
                
                // Create content
                let content = UNMutableNotificationContent()
                content.title = "Hot Coffee"
                content.body = "Your delicious coffee is ready!"
                content.categoryIdentifier = NotificationCategory.general.rawValue
                content.sound = UNNotificationSound.default // Set the notification sound
                
                // Create trigger
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 30.0, repeats: false)
                
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
    
    func playSound() {
        guard let url = Bundle.main.url(forResource: "piano-bell", withExtension: "mp3") else {
            return
        }
        
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playback, mode: .default, options: [.duckOthers])
            try session.setActive(true, options: .notifyOthersOnDeactivation) // Add .notifyOthersOnDeactivation option
            
            let player = try AVAudioPlayer(contentsOf: url)
            player.prepareToPlay()
            player.play()
        } catch {
            print("Failed to play audio: \(error)")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
