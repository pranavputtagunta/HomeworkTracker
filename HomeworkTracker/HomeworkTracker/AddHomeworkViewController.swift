//
//  ViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/14/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData

class AddHomeworkViewController: UIViewController, UITextFieldDelegate {
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
        newHomework.homeworkId = UUID().uuidString
        
        do {
            try context.save()
        } catch let error {
            print("Could not save because of \(error)")
        }
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

