//
//  EventsTableViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/15/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData
extension Date {
    func toString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
class EventsTableViewController: UITableViewController{
    var events = [Event]()
    let formatter = DateFormatter()
    func convertM(sec: Int) -> Int {
        return((sec%3600)/60)
    }
    func convertH(sec: Int) -> Int {
        return(sec/3600)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        formatter.dateFormat = "MM-dd-yy HH:mm"
        formatter.timeStyle = .none
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let context = appDelegate.persistentContainer.viewContext
        
        let fetchRequest = Event.fetchRequest() as NSFetchRequest<Event>
        
        let sortDescriptor1 = NSSortDescriptor(key: "eventTime", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            events = try context.fetch(fetchRequest)
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
        return events.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath)
        let event = events[indexPath.row]
        let eventDuration = event.eventDuration
        let i = Int(eventDuration)
        let h = convertH(sec: i)
        let m = convertM(sec: i)
        let sh = String(h)
        let sm = String(m)
        let newEventDuration = ("(" + sh + "h, " + sm + "m" + ")")
        let eventName = event.eventName ?? ""
        cell.textLabel?.text = eventName + " " + newEventDuration
        
        if let eventTime = event.eventTime as Date? {
            let eventTimeString = eventTime.toString(dateFormat: "MM-dd-yy HH:mm")
            cell.detailTextLabel?.text = "Time: " + eventTimeString
        } else {
            cell.detailTextLabel?.text = "Time unknown"
        }
        
        
        
        // Configure the cell...
        
        return cell
    }
    
    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if events.count > indexPath.row {
            let event = events[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(event)
            events.remove(at: indexPath.row)
            do {
                try context.save()
            } catch let error {
                print(error)
            }
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    
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
