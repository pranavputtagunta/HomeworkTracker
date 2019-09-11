//
//  TimesViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/26/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData

class TimesViewController: UIViewController {
    @IBOutlet var startTimeDatePicker: UIDatePicker!
    @IBOutlet var breakTimeDatePicker: UIDatePicker!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    @IBAction func saveButton(_ sender: Any) {
        let startTime = startTimeDatePicker.date
        let bufferTime = breakTimeDatePicker.countDownDuration

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
            
        let newTimes = Times(context: context)
        newTimes.startTime = startTime
        newTimes.bufferTime = bufferTime
        newTimes.timesId = UUID().uuidString

        do {
            try context.save()
        } catch let error {
            print(error)
        }
        dismiss(animated: true, completion: nil)
    }
    @IBAction func cancelButton(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
