//
//  TodoDetailsViewController.swift
//  List
//
//  Created by edan yachdav on 3/14/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit
import CoreData

class TodoDetailsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NotesViewDelegate {
    
    @IBOutlet weak var subtaskDetailInputViewHeight: NSLayoutConstraint!
    @IBOutlet weak var tableView: UITableView!
    
    var managedObjectContext: NSManagedObjectContext?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
        // Do any additional setup after loading the view.
    }
    
    private func setup() {
        subtaskDetailInputViewHeight.constant = 0
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView.contentSize.height <= tableView.frame.size.height {
            tableView.isScrollEnabled = false
        } else {
            tableView.isScrollEnabled = true
        }
        return 2 + subtaskRow
    }
    
    private var subtaskRow = 0
    private var notesRow = 1
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = UITableViewCell()
    
            switch indexPath.row {
            case 0:
                cell = tableView.dequeueReusableCell(withIdentifier: "NameDateCell", for: indexPath) as! NameDateTableViewCell
            case notesRow:
                cell = tableView.dequeueReusableCell(withIdentifier: "NotesCell", for: indexPath) as! NotesTableViewCell
                (cell as! NotesTableViewCell).notesViewDelegate = self
            default:
                cell = tableView.dequeueReusableCell(withIdentifier: "SubtaskCell",
                                                     for: indexPath) as! SubtaskTableViewCell
            }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath) as? SubtaskTableViewCell != nil {
            if editingStyle == .delete {
                notesRow -= 1
                subtaskRow -= 1
                self.tableView.deleteRows(at: [indexPath], with: .automatic)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        if indexPath.row == 0 || indexPath.row == notesRow {
            return false
        }
        
        return true
    }
    
    @IBAction func unwindNotesVC(_ sender: UIStoryboardSegue) {
        if let sourceVC = sender.source as? NotesViewController {
            let cell = tableView.cellForRow(at: IndexPath(row: notesRow, section: 0)) as! NotesTableViewCell
            cell.notesTextView.text = sourceVC.notesTextView.text
            tableView.reloadData()
        }
    }
    
    func didTapNotesView(_ notes: String) {
        performSegue(withIdentifier: "notes segue", sender: nil)
    }
    
    @IBAction func cancelTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }

    @IBAction func dontTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onSave(_ sender: UIButton) {
        guard let managedObjectContext = managedObjectContext else {return}
        
        let nameDateCell = tableView.cellForRow(at: IndexPath(row: 0,section: 0)) as? NameDateTableViewCell
        
        let newTodo = Todo(context: managedObjectContext)
        
        let name = nameDateCell?.todoNameTextField.text
        let dueDate = nameDateCell?.todoDueDateTextField.date
        
        newTodo.name = name
        newTodo.dueDate = dueDate
        
        do {
            try managedObjectContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    
    

    private func addSubtask() {
        self.subtaskDetailInputViewHeight.constant = 200.0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
    
    @IBAction func doneTapped(_ sender: UIButton) {
        self.subtaskDetailInputViewHeight.constant = 0
        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
        
        tableView.beginUpdates()
        
        subtaskRow += 1
        notesRow += 1
        let subtaskIndexPath = IndexPath(row: subtaskRow, section: 0)
        tableView.insertRows(at: [subtaskIndexPath], with: .left)
        
        tableView.endUpdates()
    }
    
    
    @IBAction func addSubTaskTapped(_ sender: UIButton) {
        addSubtask()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}


