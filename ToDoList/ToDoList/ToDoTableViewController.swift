//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Andrew Chen on 7/23/19.
//  Copyright © 2019 Andrew Chen. All rights reserved.
//

import UIKit
import UserNotifications

class ToDoTableViewController: UITableViewController, ToDoCellDelegate {
    
    var todoList = [ToDo]()
    
    func checkmarkTapped(sender: ToDoCell) {
        if let indexPath = tableView.indexPath(for: sender) {
            todoList[indexPath.row].isComplete = !todoList[indexPath.row].isComplete
            tableView.reloadRows(at: [indexPath], with: .automatic)
            ToDo.saveAll(todoList)
        }
    }
    
//    func addNotifications() {
//        let content = UNMutableNotificationContent()
//        content.title = "testing 1"
//        content.body = "testing 2"
//        // convert date to DateComponents for UNCalendar
//        let dueDate = todoList[0].dueDate
//        var dateComponents = DateComponents()
//        dateComponents.calendar = Calendar.current
//        dateComponents.weekday = 5
//        dateComponents.hour = 21
//        dateComponents.minute = 47
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
//       // dateComponents.date = dueDate
//      //  dateComponents.date = Date()
//        // Create the request
//        let uuidString = UUID().uuidString
//        let request = UNNotificationRequest(identifier: uuidString,
//                                            content: content, trigger: trigger)
//
//        // Schedule the request with the system.
//        let notificationCenter = UNUserNotificationCenter.current()
//        notificationCenter.add(request) { (error) in
//            if error != nil {
//                // Handle any errors.
//            }
//        }
//        print("done")
//    }
    
    //var todoList : [ToDo] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let savedData = ToDo.loadAll() {
            todoList = savedData
        }
        else {
            todoList = ToDo.sampleList()
        }
        // add an edit bar button item that will automatically switch from Edit to Done and vice versa
        navigationItem.leftBarButtonItem = editButtonItem
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
        //addNotifications()
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    @IBAction func unwindToToDoList(segue: UIStoryboardSegue) {
        guard segue.identifier == "saveUnwind" else { return }
        let sourceViewController = segue.source as! ToDoDetailTableViewController
        if let todo = sourceViewController.todo {
            if let selectedPath = tableView.indexPathForSelectedRow {
                let selectedRow = selectedPath.row
                todoList[selectedRow] = todo
                tableView.reloadRows(at: [selectedPath], with: .none)
            }
            else {
                let newIndexPath = IndexPath(row: todoList.count, section: 0)
                todoList.append(todo)
                tableView.insertRows(at: [newIndexPath], with: .automatic)
            }
        }
        ToDo.saveAll(todoList)
    }
    
    
    
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoList.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoCellIdentifier") as? ToDoCell else {
            fatalError("Could not dequeue a cell")
        }
        cell.delegate = self
        let todo = todoList[indexPath.row]
        cell.titleLabel?.text = todo.title
        cell.isCompleteButton.isSelected = todo.isComplete
        return cell
    }
 

    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // all cells can be edited so always return true
        return true
    }
 

    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            todoList.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            ToDo.saveAll(todoList)
            
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard segue.identifier == "EditToDo" else { return }
        let navController = segue.destination as? UINavigationController
        let toDoDetailTVC = navController?.topViewController as? ToDoDetailTableViewController
        let indexPath = tableView.indexPathForSelectedRow!
        let selectedToDo = todoList[indexPath.row]
        toDoDetailTVC?.todo = selectedToDo
        
    }
    

}
