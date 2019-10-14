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
    func isTimeInRange(comparedTime: Date, startTime: Date, endTime: Date, homeworkStart: Date, homeworkEnd: Date) -> Bool?{
        if comparedTime > startTime && comparedTime < endTime {
            if homeworkStart < startTime && homeworkEnd > endTime {
                return false
            } else {
                return true
            }
        } else {
            return false
        }
        
    }
    func isTimeRangeInTimeRange(startTimeInside: Date, endTimeInside: Date, startTimeOutside: Date, endTimeOutside: Date) -> Bool{
        if startTimeInside > startTimeOutside && endTimeInside < endTimeOutside {
            return true
        } else {
            return false
        }
    }
    func newHomeworkTimes(homeworkStart: Date, homeworkEnd: Date, homeworkDuration: Double) -> [Date?]{
        let events = [Event]()
        var newEventStartTime: Date? = nil
        var newEventEndTime: Date? = nil
        
        var newEventStartTime1: Date? = nil
        var newEventStartTime2: Date? = nil
        var newEventEndTime1: Date? = nil
        var newEventEndTime2: Date? = nil
        let numOfEvents = events.count
        for x in 0...(numOfEvents-1){
            let event = events[x]
            let startTimeInterfere = isTimeInRange(comparedTime: homeworkStart, startTime: event.eventTime!, endTime: (event.eventTime!+event.eventDuration), homeworkStart: homeworkStart, homeworkEnd: homeworkEnd)
            let eventInside = isTimeRangeInTimeRange(startTimeInside: event.eventTime!, endTimeInside: (event.eventTime!+event.eventDuration), startTimeOutside: homeworkStart, endTimeOutside: homeworkEnd)
            let endTimeInterfere = isTimeInRange(comparedTime: homeworkEnd, startTime: event.eventTime!, endTime: (event.eventTime!+event.eventDuration), homeworkStart: homeworkStart, homeworkEnd: homeworkEnd)
            let homeworkInside = isTimeRangeInTimeRange(startTimeInside: homeworkStart, endTimeInside: homeworkEnd, startTimeOutside: event.eventTime!, endTimeOutside: (event.eventTime!+event.eventDuration))
            if startTimeInterfere == true || homeworkInside == true{
                newEventStartTime = (event.eventTime! + event.eventDuration)
                newEventEndTime = (newEventStartTime! + homeworkDuration)
            }
            if endTimeInterfere  == true || eventInside == true {
                newEventStartTime1 = homeworkStart
                newEventEndTime1 = event.eventTime!
                let timeSpent = Calendar.current.dateComponents([.second], from: homeworkStart, to: newEventEndTime1!).second
                newEventStartTime2 = (event.eventTime! + event.eventDuration)
                let timeSpentDouble = Double(timeSpent!)
                let timeLeft = (homeworkDuration - timeSpentDouble)
                newEventEndTime2 = (newEventStartTime2! + timeLeft)
                
            }
        }
        return [newEventStartTime, newEventEndTime, newEventStartTime1, newEventEndTime1, newEventStartTime2, newEventEndTime2]
    }
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
    //[newEventStartTime, newEventEndTime, newEventStartTime1, newEventEndTime1, newEventStartTime2, newEventEndTime2]
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
        let homeworkTimes = newHomeworkTimes(homeworkStart: startTimeOG, homeworkEnd: endTimeOG, homeworkDuration: ttsDou)
        if homeworkTimes[1] != nil{
            cell.detailTextLabel?.text = homeworkTimes[0]!.convertString(dateFormat: "HH:mm") + " - " + homeworkTimes[1]!.convertString(dateFormat: "HH:mm")
            timex = homeworkTimes[1]!
        } else {
            if homeworkTimes[5] != nil {
                let num1 = homeworkTimes[2]!.convertString(dateFormat: "HH:mm")
                let num2 = homeworkTimes[3]!.convertString(dateFormat: "HH:mm")
                let num3 = homeworkTimes[4]!.convertString(dateFormat: "HH:mm")
                let num4 = homeworkTimes[5]!.convertString(dateFormat: "HH:mm")
                cell.detailTextLabel?.text = num1 + " - " + num2 + ", " + num3 + " - " + num4
                timex = homeworkTimes[5]!
            } else {
                cell.detailTextLabel?.text = startTimeString + " - " + endTimeString
                timex = endTimeOG
            }
        }


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
