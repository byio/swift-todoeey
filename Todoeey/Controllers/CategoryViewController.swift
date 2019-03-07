//
//  CategoryViewController.swift
//  Todoeey
//
//  Created by BenYang on 3/4/19.
//  Copyright © 2019 BenYang. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController {
    
    // create a new realm instance
    let realm = try! Realm()
    
    var categories: Results<Category>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.separatorStyle = .none
        
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
            // this can be nil because if destinationVC.selectedCategory is nil, items won't load
            destinationVC.selectedCategory = categories?[indexPath.row]
        }
        
    }
    
    // MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // grab cell from cell created in SwipeTableViewController (which is a superclass of this controller)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categories?[indexPath.row] {
            cell.textLabel?.text = category.name
            cell.backgroundColor = UIColor(hexString: category.cellColorHex)
        }
        else {
            cell.textLabel?.text = "No Categories Added Yet"
            cell.backgroundColor = UIColor(hexString: "1D9BF6")
        }
        
//        // update textLabel property of cell (defaults to "No Categories Added")
//        cell.textLabel?.text = categories?[indexPath.row].name ?? "No Categories Added"
//
//        // modify cell bg color
//        cell.backgroundColor = UIColor(hexString: (categories?[indexPath.row].cellColorHex)!)
        
        // return cell
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        // nil coalescing operator; if categories != nil return count otherwise return 1
        return categories?.count ?? 1
        
    }
    
    // MARK: - Data (Model) Manipulation Methods
    func save(category: Category) {
        
        // save input
        do {
            try realm.write {
                realm.add(category)
            }
        }
        catch {
            print("Error saving to realm \(error)")
        }
        
        // reload data in tableView
        tableView.reloadData()
        
    }
    
    func loadCategories() {
        
        // fetch data
        categories = realm.objects(Category.self)
        
        // reload data in tableView
        tableView.reloadData()
        
    }
    
    // MARK: - Delete Data with Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let swipedItem = self.categories?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(swipedItem)
                }
            }
            catch {
                print("Error deleting category from Realm: \(error)")
            }
        }
    }
    
    // MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        // create UIAlertController object instance
        let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
        
        // create UIAlertAction
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            
            // append category to categoryArray
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.cellColorHex = UIColor.randomFlat.hexValue()
            
            // save category
            self.save(category: newCategory)
            
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
