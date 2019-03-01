//
//  ViewController.swift
//  Todoeey
//
//  Created by BenYang on 2/26/19.
//  Copyright © 2019 BenYang. All rights reserved.


import UIKit

class TodoListViewController: UITableViewController {
    
    // create a file path to the documents folder in the file system (singleton)
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    // create itemArray as an Array of Item objects
    var itemArray = [Item]()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        // load data from Items.plist
        loadItems()
        
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // grab item
        let item = itemArray[indexPath.row]
        
        // create cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        // update textLabel property of cell
        cell.textLabel?.text = item.title
        
        // update accessoryType property of cell
        /*
         if item.done (ie. true), cell.accessoryType = .checkmark, else = .none
        */
        cell.accessoryType = item.done ? .checkmark : .none
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return itemArray.count
        
    }
    
    // MARK: - TableView Delegate Methods
        // this method is called whenever a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // check done property of each item in itemArray
        itemArray[indexPath.row].done = !itemArray[indexPath.row].done
        
        // saveItem to Items.plist (with NSCoder)
        saveItem()
        
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
            let newItem = Item()
            newItem.title = textField.text!
            self.itemArray.append(newItem)
            
            // saveItem to Items.plist (with NSCoder)
            self.saveItem()
            
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
    
    // MARK: - Model Manipulation Methods
    func saveItem() {
        
        // create PropertListEncoder instance
        let encoder = PropertyListEncoder()
        
        do {
            // encode data
            let data = try encoder.encode(itemArray)
            // write data to dataFilePath
            try data.write(to: dataFilePath!)
        }
        catch {
            print("Error saving data: \(error)")
        }
        
        // TODO: - reload data in tableView
        self.tableView.reloadData()
    }
    
    func loadItems() {
        
        // create constant to store data retrieved from Items.plist
        if let data = try? Data(contentsOf: dataFilePath!) {
            
            // create PropertyListDecoder instance
            let decoder = PropertyListDecoder()
            
            // decode data into itemArray
            do {
                itemArray = try decoder.decode([Item].self, from: data)
            }
            catch {
                print("Error loading items: \(error)")
            }
            
        }
        
    }

}

