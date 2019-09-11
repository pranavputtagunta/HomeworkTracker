//
//  AddEventViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/15/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
class AddEventViewController: UIViewController {
    
    @IBOutlet var eventNameTextField: UITextField!
    @IBOutlet var eventTimeDatePicker: UIDatePicker!
    @IBOutlet var eventDurationDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        let eventName = eventNameTextField.text ?? ""
        let eventTime = eventTimeDatePicker.date
        let eventDuration = eventDurationDatePicker.countDownDuration
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newEvent = Event(context: context)
        newEvent.eventName = eventName
        newEvent.eventTime = eventTime
        newEvent.eventDuration = eventDuration
        newEvent.eventId = UUID().uuidString
        
        
        do {
            try context.save()
            let message = "\(eventName) is happening today. Don't miss it!"
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: eventTime)
            dateComponents.hour = 7
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newEvent.eventId {
                
                let request  = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
                let center = UNUserNotificationCenter.current()
                center.add(request, withCompletionHandler: nil)
            }
            
        } catch let error {
            print("Could not save because of \(error)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
