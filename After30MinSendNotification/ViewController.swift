//
//  ViewController.swift
//  After30MinSendNotification
//
//  Created by Dipak on 23/01/17.
//  Copyright © 2017 Dipak. All rights reserved.
//


import UIKit
import  UserNotifications
import UserNotificationsUI //framework to customize the notification

class ViewController: UIViewController {
    
    let requestIdentifier = "DipakRequest" //identifier is to cancel the notification request
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    @IBAction  func triggerNotification(){
        let content = UNMutableNotificationContent()
        content.title = "Notifications"
        content.subtitle = "Repeated"
        content.body = "Dipak"
        content.sound = UNNotificationSound.default()
        
        //To Present image in notification
        if let path = Bundle.main.path(forResource: "Falcon-48", ofType: "png") {
            let url = URL(fileURLWithPath: path)
            
            do {
                let attachment = try UNNotificationAttachment(identifier: "sampleImage", url: url, options: nil)
                content.attachments = [attachment]
            } catch {
                print("attachment not found.")
            }
        }
        
        // Deliver the notification in five seconds.
        let trigger = UNTimeIntervalNotificationTrigger.init(timeInterval: 60.0, repeats: true)
        let request = UNNotificationRequest(identifier:requestIdentifier, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().add(request){(error) in
            
            if (error != nil){
                
                print(error?.localizedDescription ?? "")
            }
        }
    }
    
    @IBAction func stopNotification(_ sender: AnyObject) {
        
        print("Removed all pending notifications")
        let center = UNUserNotificationCenter.current()
        center.removePendingNotificationRequests(withIdentifiers: [requestIdentifier])
        
    }
}

extension ViewController:UNUserNotificationCenterDelegate{
    
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
        print("Tapped in notification")
    }
    
    //This is key callback to present notification while the app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("Notification being triggered")
        //You can either present alert ,sound or increase badge while the app is in foreground too with ios 10
        //to distinguish between notifications
        if notification.request.identifier == requestIdentifier{
            
            completionHandler( [.alert,.sound,.badge])
            
        }
    }
}

