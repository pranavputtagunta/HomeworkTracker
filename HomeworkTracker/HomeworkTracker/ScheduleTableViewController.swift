//
//  ScheduleTableViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/26/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData

class ScheduleTableViewController: UITableViewController {
    
    var homeworks = [Homework]()
    var times = [Times]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Homework.fetchRequest() as NSFetchRequest<Homework>
        
        let sortDescriptor1 = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            homeworks = try context.fetch(fetchRequest)
        } catch let error {
            print(error)
        }
        let appDelegate2 = UIApplication.shared.delegate as! AppDelegate
        let context2 = appDelegate2.persistentContainer.viewContext
        let fetchRequest2 = Times.fetchRequest() as NSFetchRequest<Times>
        
        do {
            times = try context2.fetch(fetchRequest2)
        } catch let error {
            print(error)
        }
        tableView.reloadData()
    }
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return homeworks.count
    }

    var timex: Date = Date()
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ScheduleCell", for: indexPath)
        
        var startTimeString = ""
        var endTimeString = ""
        let homework = homeworks[indexPath.row]
        let time = times[0]
        if indexPath.row == 0 {
            timex = time.startTime ?? Date()
        }
        cell.textLabel?.text = homework.homeworkName
        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to:homework.dueDate!).day! - 1
        let ttsInt = Int(homework.completionTime)/daysLeft
        let ttsDou = Double(ttsInt)
        let startTimeOG = timex
        if let startTime = startTimeOG as Date? {
            startTimeString = startTime.convertString(dateFormat: "HH:mm")
        } else {
            cell.detailTextLabel?.text = "You did not enter one or more of the times. Please click 'Change Times' to set your times."
        }
        let endTimeOG = startTimeOG + ttsDou
        if let endTime = endTimeOG as Date? {
            endTimeString = endTime.convertString(dateFormat: "HH:mm")
            
        } else {
            cell.detailTextLabel?.text = "You did not enter one or more of the times. Please click 'Change Times' to set your times."
        }
        cell.detailTextLabel?.text = startTimeString + " - " + endTimeString
        timex = endTimeOG

        return cell
    }
    

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
