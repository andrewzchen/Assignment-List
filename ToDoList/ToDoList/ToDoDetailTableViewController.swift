//
//  ToDoDetailTableViewController.swift
//  ToDoList
//
//  Created by Andrew Chen on 7/23/19.
//  Copyright © 2019 Andrew Chen. All rights reserved.
//

import UIKit


class ToDoDetailTableViewController: UITableViewController {
    
    var todo : ToDo?
    var isAssignmentComplete = false // is assigment complete? default as false
    var isPickerHidden = true // is date picker hidden
    // index pathes used in setting height of each table cell
    let dateLabelIndexPath = IndexPath(row: 0, section: 1)
    let datePickerIndexPath = IndexPath(row: 1, section: 1)
    let notesIndexPath = IndexPath(row: 0, section: 3)
    
    
    @IBOutlet var doneButtonRow: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        // check if the user clicked + button for a new ToDo or is editing a cell
        if let todo = todo {
            titleTextField.text = todo.title
            isAssignmentComplete = todo.isComplete
            doneButtonRow.isHidden = isAssignmentComplete
        //    isCompleteButton.isSelected = todo.isComplete
            dueDateLabel.text = ToDo.duoDateFormatter.string(from: todo.dueDate)
            dueDatePicker.date = todo.dueDate
            if (todo.classType == className.CS270) {
                classSegmentedControl.selectedSegmentIndex = 0
            }
            else if (todo.classType == className.CS356) {
                classSegmentedControl.selectedSegmentIndex = 1
            }
            else if (todo.classType == className.CTWR211) {
                classSegmentedControl.selectedSegmentIndex = 2
            }
            else {
                classSegmentedControl.selectedSegmentIndex = 3
            }
         //   classSegmentedControl.selectedSegmentIndex
            notesTextView.text = todo.notes
        }
        else { // new ToDo : no data to load in
            dueDatePicker.date = Date().addingTimeInterval(24*60*60)
            classSegmentedControl.selectedSegmentIndex = 0
        }
        
        updateSaveButtonState()
        updateDueDateLabel()
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    @IBOutlet var isCompleteButton: UIButton!
    @IBOutlet var titleTextField: UITextField!
    
    
    @IBOutlet var dueDateLabel: UILabel!
    @IBOutlet var dueDatePicker: UIDatePicker!
    
    @IBOutlet var classSegmentedControl: UISegmentedControl!
    @IBOutlet var notesTextView: UITextView!
    
    @IBOutlet var saveButton: UIBarButtonItem!
    
    @IBOutlet var doneButton: UIButton!
    @IBAction func doneButtonPressed(_ sender: UIButton) {
        let dialogMessage = UIAlertController(title: "Confirm", message: "Are you sure you've completed the assignment?", preferredStyle: .alert)
        
        let accept = UIAlertAction(title: "Accept", style: .default, handler: {(action) -> Void in print("accepted")
//          // Go back to main screen
            // mark isComplete as true, indicating assignment can be deleted
            self.isAssignmentComplete = true
            self.performSegue(withIdentifier: "saveUnwind", sender: self)
        })
        
        let cancel = UIAlertAction(title: "Cancel", style: .cancel, handler: { (action) -> Void in print("canceled")
            
            })
        
        dialogMessage.addAction(accept)
        dialogMessage.addAction(cancel)
        
        
        // show dialog message
        self.present(dialogMessage, animated: true, completion: nil)
        
    }
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    @IBAction func returnButtonPressed(_ sender: UITextField) {
        // hide keyboard
        titleTextField.resignFirstResponder()
    }
//    @IBAction func isCompleteButtonTapped(_ sender: UIButton) {
//        isCompleteButton.isSelected = !isCompleteButton.isSelected
//    }
    @IBAction func dueDatePickerChanged(_ sender: Any) {
        updateDueDateLabel()
    }
    func updateSaveButtonState() {
        let title = titleTextField.text ?? ""
        saveButton.isEnabled = !title.isEmpty
    }
    
    func updateDueDateLabel() {
        dueDateLabel.text = ToDo.duoDateFormatter.string(from: dueDatePicker.date)
        // consider adding code to add 1 day to original due date
    }
    
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath == datePickerIndexPath) {
            // if Picker is hidden : 0 else the height of picker
            return isPickerHidden ? 0 : dueDatePicker.frame.height
        }
        else if (indexPath == notesIndexPath) {
            return 200
        }
        else {
            return 44
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            isPickerHidden = !isPickerHidden
            // change color of Due Date text based on if picker is hidden
            dueDateLabel.textColor = isPickerHidden ? .black : tableView.tintColor
            // call heightForRowAt again to adjust picker cell height
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
//
//    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        // #warning Incomplete implementation, return the number of rows
//        return 0
//    }

    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

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

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = titleTextField.text!
       // let isComplete = isCompleteButton.isSelected
        let isComplete = isAssignmentComplete
        let dueDate = dueDatePicker.date
        let index = classSegmentedControl.selectedSegmentIndex
        var selectedClass = className.CS270
        if (index == 1) {
            selectedClass = className.CS356
        }
        else if (index == 2) {
            selectedClass = className.CTWR211
        }
        else if (index == 3) {
            selectedClass = className.ITP303
        }
        let notes = notesTextView.text
        
        todo = ToDo(title: title, dueDate: dueDate, isComplete: isComplete, classType: selectedClass, notes: notes)
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
