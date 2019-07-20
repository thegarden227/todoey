//
//  ViewController.swift
//  todoey
//
//  Created by Joy@work on 15/7/2562 BE.
//  Copyright © 2562 joyful. All rights reserved.
//

import UIKit

class ToDoListViewController: UITableViewController {

    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Gogon"]
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        } else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }


    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        
        var newItemText = UITextField()
        let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            self.itemArray.append(newItemText.text!)
            self.tableView.reloadData()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new item..."
            newItemText = alertTextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
}

