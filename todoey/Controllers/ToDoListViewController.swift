//
//  ViewController.swift
//  todoey
//
//  Created by Joy@work on 15/7/2562 BE.
//  Copyright © 2562 joyful. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {

    let userDefaults = UserDefaults.standard
//    var itemArray = ["Find Mike", "Buy Eggs", "Destroy Gogon"]
    var todoListItemArray = [TodoListItemEntity]()
    let coreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("todoListItem.plist")
    var selectedCategory: Category? {
        didSet{
            loadTodoListItems()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoListItemArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        var todoListItem = TodoListItemEntity()
        todoListItem = todoListItemArray[indexPath.row]
        
        cell.textLabel?.text = todoListItem.title
        
        cell.accessoryType = todoListItem.isDone ? UITableViewCell.AccessoryType.checkmark : UITableViewCell.AccessoryType.none
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        todoListItemArray[indexPath.row].isDone = !todoListItemArray[indexPath.row].isDone
        saveTodoListItems()
//        tableView.reloadData()
        tableView.deselectRow(at: indexPath, animated: true)
    }


    @IBAction func addNewItemPressed(_ sender: UIBarButtonItem) {
        
        var newItemText = UITextField()
       
        let alertController = UIAlertController(title: "Add New Item", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            
            let newTodoItem = TodoListItemEntity(context: self.coreDataContext)
            newTodoItem.title = newItemText.text!
            newTodoItem.parentCategory = self.selectedCategory
            self.todoListItemArray.append(newTodoItem)
            self.saveTodoListItems()
        }
        
        alertController.addTextField { (alertTextField) in
            alertTextField.placeholder = "add new item..."
            newItemText = alertTextField
        }
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
//
//    func saveTodoItems() -> Void {
//        let encoder = PropertyListEncoder()
//
//        do {
//            let encodedData = try encoder.encode(self.todoListItemArray)
//            try encodedData.write(to: self.dataFilePath!)
//        } catch {
//            print(error)
//        }
//        self.tableView.reloadData()
//
//    }
    
    private func saveTodoListItems() -> Void {
        do {
            try coreDataContext.save()
        } catch {
            print(error)
        }
        self.tableView.reloadData()
    }
    
    public func loadTodoListItems(with todoListRequest: NSFetchRequest<TodoListItemEntity> = TodoListItemEntity.fetchRequest(), witPredicate todoListPredicate: NSPredicate? = nil ) -> Void {
        
        let categoryPredicate = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        if let additionalPrecidate = todoListPredicate {
            todoListRequest.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, todoListPredicate!])
            
            
        } else {
            todoListRequest.predicate = categoryPredicate
        }
        
        
        do {
           todoListItemArray = try coreDataContext.fetch(todoListRequest)
        } catch {
            print(error)
        }
        
        tableView.reloadData()
    }
    
//    func loadTodoItems() -> Void {
//
//        if let loadingData = try? Data(contentsOf: dataFilePath!) {
//            let decoder = PropertyListDecoder()
//            do {
//                todoListItemArray = try decoder.decode([TodoListItem].self, from: loadingData)
//            } catch {
//                print(error)
//            }
//        }
//
//    }
}

//MARK: - Search Bar method
extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let todoListRequest: NSFetchRequest<TodoListItemEntity> = TodoListItemEntity.fetchRequest()
        let todoListPredicate: NSPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        todoListRequest.predicate = todoListPredicate
        let todoListSortDescriptor: NSSortDescriptor = NSSortDescriptor(key: "title", ascending: true)
        todoListRequest.sortDescriptors = [todoListSortDescriptor]
        
        loadTodoListItems(with: todoListRequest, witPredicate: todoListPredicate)
    }
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadTodoListItems()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }
        
    }

}

