//
//  ViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/14/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

class AddHomeworkViewController: UIViewController, UITextFieldDelegate {
    var tts = 0
    func convertDays(min: Int) -> Int {
        return(min/1440)
    }
    func convertHours(min: Int) -> Int{
        return((min%1440)/60)
    }
    func convertMinutes(min: Int) -> Int {
        return((min%1440)%60)
    }
    func convertAll(min: Int) -> (Int, Int, Int) {
        let hours = convertHours(min: min)
        let minutes = convertMinutes(min: min)
        let days = convertDays(min: min)
        return(days, hours, minutes)
    }
    @IBOutlet var homeworkNameTextField: UITextField!
    @IBOutlet var dueDateDatePicker: UIDatePicker!
    @IBOutlet var completionTimeDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    @IBAction func saveButton(_ sender: Any) {
        let homeworkName = homeworkNameTextField.text ?? ""
        let dueDate = dueDateDatePicker.date
        let completionTime = completionTimeDatePicker.countDownDuration
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let newHomework = Homework(context: context)
        newHomework.homeworkName = homeworkName
        newHomework.dueDate = dueDate
        newHomework.completionTime = completionTime
        newHomework.timeSpent = 0
        newHomework.timeLeft = completionTime - newHomework.timeSpent
        newHomework.homeworkId = UUID().uuidString
        

        
        do {
            try context.save()
            let message = "\(homeworkName) is due today. Make sure to complete it."
            let content = UNMutableNotificationContent()
            content.body = message
            content.sound = UNNotificationSound.default
            var dateComponents = Calendar.current.dateComponents([.month, .day], from: dueDate)
            dateComponents.hour = 7
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            if let identifier = newHomework.homeworkId {
                
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

