//
//  EditHomeworkViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/15/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData
class EditHomeworkViewController: UIViewController {
    @IBOutlet var homeworkPicker: UIPickerView!
    @IBOutlet var newDueDateDatePicker: UIDatePicker!
    @IBOutlet var newCompletionTimeDatePicker: UIDatePicker!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveButton(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
