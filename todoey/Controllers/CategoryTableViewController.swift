//
//  CategoryTableViewController.swift
//  todoey
//
//  Created by Glory Joy on 21/7/2562 BE.
//  Copyright © 2562 joyful. All rights reserved.
//

import UIKit
import CoreData

class CategoryTableViewController: UITableViewController {

    var categoryArray = [Category]()
    let categoryCoreDataContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBAction func addCategoryButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField: UITextField = UITextField()
        
        let alertController = UIAlertController(title: "Add Category", message: "", preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let category = Category(context: self.categoryCoreDataContext)
            category.name = textField.text
            self.categoryArray.append(category)
            self.saveCategory()
        }
        
        alertController.addAction(alertAction)
        alertController.addTextField { (field) in
            textField = field
            textField.placeholder = "Add new category"
            
            
        }
        present(alertController, animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategory()
        
    }
    // MARK: - Table view data source

    
    //MARK: - Tableview Datasource Methods
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return categoryArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "categoryCell", for: indexPath)
        cell.textLabel?.text = categoryArray[indexPath.row].name
        return cell
    }
    //MARK: - TableView Delegate Methods
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    public override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationViewController = segue.destination as! ToDoListViewController
        
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationViewController.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    //MARK: - Add New Category

    //MARK: - Data Manipulation Methods
    public func saveCategory() -> Void {
        do {
            try categoryCoreDataContext.save()
        } catch {
            print(error)
        }
        
        tableView.reloadData()
        
    }
    
    public func loadCategory() {
        
        let categoryRequest: NSFetchRequest<Category> = Category.fetchRequest()
        
        do {
            categoryArray = try categoryCoreDataContext.fetch(categoryRequest)
        } catch {
            print(error)
        }
    }
}
