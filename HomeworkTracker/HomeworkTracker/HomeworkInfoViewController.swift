//
//  homeworkInfoViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/25/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData


class HomeworkInfoViewController: UIViewController {
    var homework: Homework?

    func convertM(sec: Int) -> Int {
        return((sec%3600)/60)
    }
    func convertH(sec: Int) -> Int {
        return(sec/3600)
    }
    func setValues()
    {
        let dueDate = homework?.dueDate ?? Date()
        let completionTime = homework?.completionTime ?? 0
        let i = Int(completionTime)
        let h = convertH(sec: i)
        let m = convertM(sec: i)
        let sh = String(h)
        let sm = String(m)
        let newCompletionTime = sh + "h, " + sm + "m"
        
        homeworkNameLabel.text = homework?.homeworkName
        let dueDateString = dueDate.convertString(dateFormat: "MM-dd-yy HH:mm")
        dueDateLabel.text = dueDateString
        completionTimeLabel.text = newCompletionTime
    }
    @IBOutlet var homeworkNameLabel: UILabel!
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var completionTimeLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        setValues()

        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editHomework" {
            let destinationVC: EditHomeworkViewController = segue.destination as! EditHomeworkViewController
            destinationVC.homework = homework
        }
    }
    @IBAction func unwindFromSave(sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? EditHomeworkViewController, let editedHomework = sourceVC.homework{
            homework = editedHomework
            setValues()
        }
    }
}
