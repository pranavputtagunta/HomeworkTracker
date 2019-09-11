//
//  EditHomeworkViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/25/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData
class EditHomeworkViewController: UIViewController {
    var homework: Homework?

    var tts = 0
    @IBOutlet var newHomeworkNameTextField: UITextField!
    @IBOutlet var newDueDateDatePicker: UIDatePicker!
    @IBOutlet var newCompletionTimeDatePicker: UIDatePicker!
    @IBOutlet var saveButton: UIBarButtonItem!
    override func viewDidLoad() {
        super.viewDidLoad()
        newHomeworkNameTextField.text = homework?.homeworkName ?? ""
        newDueDateDatePicker.date = homework?.dueDate ?? Date()
        newCompletionTimeDatePicker.countDownDuration = homework?.completionTime ?? 0
        
    }
    @IBAction func saveButton(_ sender: Any) {
        homework?.homeworkName = newHomeworkNameTextField.text ?? ""
        homework?.dueDate = newDueDateDatePicker.date
        homework?.completionTime = newCompletionTimeDatePicker.countDownDuration
        
    }

    func setHomework(homework: Homework?) {
        newHomeworkNameTextField.text = homework?.homeworkName ?? ""
        newDueDateDatePicker.date = homework?.dueDate ?? Date()
        newCompletionTimeDatePicker.countDownDuration = homework?.completionTime ?? 0
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        guard let button = sender as? UIBarButtonItem, button === saveButton else{
            print("hi")
            return()
        }
        homework?.homeworkName = newHomeworkNameTextField.text ?? ""
        homework?.dueDate = newDueDateDatePicker.date
        homework?.completionTime = newCompletionTimeDatePicker.countDownDuration
        

    }
    
}
