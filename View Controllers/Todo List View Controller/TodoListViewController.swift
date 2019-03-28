//
//  TodoListViewController.swift
//  List
//
//  Created by edan yachdav on 3/2/19.
//  Copyright © 2019 edan yachdav. All rights reserved.
//

import UIKit
import CoreData

class TodoListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var todosTableView: UITableView!
    
    private let persistentContainer = NSPersistentContainer(name: "List")
    fileprivate lazy var fetchedResultsController: NSFetchedResultsController<Todo> = {
        //Create Fetch Request
        let fetchRequest: NSFetchRequest<Todo> = Todo.fetchRequest()
        // Configure Fetch Request
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        // Create Fetched Results Controller
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: self.persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        // Configure Fetched Results Controller
        fetchedResultsController.delegate = self
        
        return fetchedResultsController
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        todosTableView.dataSource = self
        todosTableView.delegate = self
        
        persistentContainer.loadPersistentStores { (persistantStoreDescription, error) in
            if let error = error {
                print("Unable to load persistent store")
                print("\(error), \(error.localizedDescription)")
            } else {
                do {
                    try self.fetchedResultsController.performFetch()
                } catch {
                    let fetchError = error as NSError
                    print("Unable to Perform Fetch Request")
                    print("\(fetchError), \(fetchError.localizedDescription)")
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        do {
            try self.fetchedResultsController.performFetch()
        } catch {
            let fetchError = error as NSError
            print("Unable to Perform Fetch Request")
            print("\(fetchError), \(fetchError.localizedDescription)")
        }
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        todosTableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        todosTableView.endUpdates()
        todosTableView.reloadData()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case .insert:
            if let indexPath = newIndexPath {
                todosTableView.insertRows(at: [indexPath], with: .fade)
            }
            break;
        default:
            print("...")
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let todos = fetchedResultsController.fetchedObjects else { return 0 }
        return todos.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(50)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = todosTableView.dequeueReusableCell(withIdentifier: "Todo Cell", for: indexPath) as? TodoTableViewCell else {
            fatalError("Unexpected index path")
        }
        
        let todo = fetchedResultsController.object(at: indexPath)
        cell.name.text = todo.name
        
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MM-yyyy"
        let dateString = formatter.string(from: todo.dueDate!)
        cell.date.text = dateString
        
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Show Todo Detail" {
            if let destVC = segue.destination as? TodoDetailsViewController {
                destVC.managedObjectContext = persistentContainer.viewContext
            }
        }
    }

}
