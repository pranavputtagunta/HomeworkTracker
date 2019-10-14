//
//  HomeworkTableViewController.swift
//  HomeworkTracker
//
//  Created by user157777 on 8/15/19.
//  Copyright © 2019 user157777. All rights reserved.
//

import UIKit
import CoreData
extension Date {
    func convertString(dateFormat format: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
class HomeworksTableViewController: UITableViewController {
    var homeworks = [Homework]()
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
        
        let fetchRequest = Homework.fetchRequest() as NSFetchRequest<Homework>

        
        let sortDescriptor1 = NSSortDescriptor(key: "dueDate", ascending: true)
        fetchRequest.sortDescriptors = [sortDescriptor1]
        do {
            homeworks = try context.fetch(fetchRequest)
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
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HomeworksCell", for: indexPath)
        let homework = homeworks[indexPath.row]
        let completionTime = homework.completionTime
        let i = Int(completionTime)
        let h = convertH(sec: i)
        let m = convertM(sec: i)
        let sh = String(h)
        let sm = String(m)
        let newCompletionTime = ("(" + sh + "h, " + sm + "m" + ")")
        let homeworkName = homework.homeworkName ?? ""
        cell.textLabel?.text = homeworkName + " " + newCompletionTime
        
        if let dueDate = homework.dueDate as Date? {
            let dueDateString = dueDate.convertString(dateFormat: "MM-dd-yy HH:mm")
            cell.detailTextLabel?.text = "Due date: " + dueDateString
        } else {
            cell.detailTextLabel?.text = " Due date unknown"
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
        if homeworks.count > indexPath.row {
            let homework = homeworks[indexPath.row]
            
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            let context = appDelegate.persistentContainer.viewContext
            context.delete(homework)
            homeworks.remove(at: indexPath.row)
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
    var selectedHomework: Homework?
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let homework = homeworks[indexPath.row]
        selectedHomework = homework
    }
    */
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeworksInfo" {
            let destinationVC: HomeworkInfoViewController = segue.destination as! HomeworkInfoViewController
            guard let selectedHomeworkCell = sender as? UITableViewCell else {
                fatalError("error with cell")
            }
            guard let indexPath = tableView.indexPath(for: selectedHomeworkCell) else {
                fatalError("could not get cell")
            }
            destinationVC.homework = homeworks[indexPath.row]
        }
        
        
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
    
    
}
