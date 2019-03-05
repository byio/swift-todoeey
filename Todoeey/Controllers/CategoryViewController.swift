//
//  CategoryViewController.swift
//  Todoeey
//
//  Created by BenYang on 3/4/19.
//  Copyright © 2019 BenYang. All rights reserved.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    // define persistent context for data manipulation
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var categoryArray = [Category]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCategories()
    }
    
    // MARK: - TableView Delegate Methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // perform goToItems segue
        performSegue(withIdentifier: "goToItems", sender: self)
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // grab destination ViewController
        let destinationVC = segue.destination as! TodoListViewController
        
        // set selectedCategory property in TodoListVC to current category
        if let indexPath = tableView.indexPathForSelectedRow {
            destinationVC.selectedCategory = categoryArray[indexPath.row]
        }
        
    }
    
    // MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // grab category to display in cell
        let category = categoryArray[indexPath.row]
        
        // create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        // update textLabel property of cell
        cell.textLabel?.text = category.name
        
        // return cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return categoryArray.count
        
    }
    
    // MARK: - Data (Model) Manipulation Methods
    func saveCategory() {
        
        // save input
        do {
            try context.save()
        }
        catch {
            print("Error saving to context \(error)")
        }
        
        // reload data in tableView
        tableView.reloadData()
        
    }
    
    func loadCategories(with request: NSFetchRequest<Category> = Category.fetchRequest()) {
        
        // fetch data
        do {
            categoryArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
        // reload data in tableView
        tableView.reloadData()
        
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // create UIAlertController object instance
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // create UIAlertAction
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // append category to categoryArray
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text
            self.categoryArray.append(newCategory)
            
            // save category
            self.saveCategory()
            
        }
        
        // create UITextField for user input
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "Create New Category"
            
            textField = alertTextField
            
        }
        
        // add UIAlertAction to UIAlertController
        alert.addAction(action)
        
        // display alert object as a modal
        present(alert, animated: true, completion: nil)
        
    }
    
}
