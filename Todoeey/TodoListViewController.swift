//
//  ViewController.swift
//  Todoeey
//
//  Created by BenYang on 2/26/19.
//  Copyright © 2019 BenYang. All rights reserved.


import UIKit

class TodoListViewController: UITableViewController {
    
    // create new UserDefaults object
    let defaults = UserDefaults.standard
    
    // temp data arr
    var itemArray = ["Find Mike", "Buy eggos", "Destroy Demogorgon"]

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // set itemArray as array saved in UserDefaults (use optional binding because TodoListArray might be nil)
        if let items = defaults.array(forKey: "TodoListArray") as? [String] {
            itemArray = items
        }
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = itemArray[indexPath.row]
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    // MARK: - TableView Delegate Methods
        // this method is called whenever a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check if selected cell has accessoryType == .checkmark
        if tableView.cellForRow(at: indexPath)?.accessoryType == .checkmark {
            tableView.cellForRow(at: indexPath)?.accessoryType = .none
        }
        else {
            tableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
        }
        
        // selecting an item will now cause the cell to flash gray instead of stay gray
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    // MARK: - IBAction to handle addButtonPressed (adding new todo item)
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        // locally scoped var
        var textField = UITextField()
        
        // create a UIAlertController object instance
        let alert = UIAlertController(title: "Add New Todoeey Item", message: "", preferredStyle: .alert)
        
        // UIAlertAction object (closure will fire whenever addButton is pressed)
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            
            // TODO: - append item to itemArray
            self.itemArray.append(textField.text!)
            
            // save updated itemArray to UserDefaults (defaults)
            self.defaults.set(self.itemArray, forKey: "TodoListArray")
            
            // TODO: - reload data in tableView
            self.tableView.reloadData()
            
        }
        
        // add textfield to alert so users can type todo item in textfield
        alert.addTextField { (alertTextField) in
            
            // define placeholder in alertTextField
            alertTextField.placeholder = "Create New Item"
            
            // update textField var to hold user input
            textField = alertTextField
            
        }
        
        // add action to alert
        alert.addAction(action)
        
        // present alert object modally
        present(alert, animated: true, completion: nil)
        
    }
    

}

