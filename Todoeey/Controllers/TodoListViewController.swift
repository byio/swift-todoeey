//
//  ViewController.swift
//  Todoeey
//
//  Created by BenYang on 2/26/19.
//  Copyright © 2019 BenYang. All rights reserved.


import UIKit
import RealmSwift
import ChameleonFramework

class TodoListViewController: SwipeTableViewController {
    
    // create new realm instance
    let realm = try! Realm()
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // initialize itemArray as an Array of Item objects
    var todoItems: Results<Item>?
    
    // property that interfaces with CategoryViewController
    var selectedCategory: Category? {
        // code below triggers once optional variable is set
        didSet {
            
            // load data
            loadItems()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        
        tableView.separatorStyle = .none
    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // grab cell from cell created in SwipeTableViewController (which is a superclass of this controller)
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let item = todoItems?[indexPath.row] {
            let rootColor = UIColor(hexString: (selectedCategory?.cellColorHex)!)
            let darkenPercent = CGFloat(indexPath.row) / CGFloat(todoItems!.count)
            
            cell.backgroundColor = rootColor?.darken(byPercentage: darkenPercent)
            cell.textLabel?.textColor = ContrastColorOf(cell.backgroundColor!, returnFlat: true)
            cell.textLabel?.text = item.title
            cell.accessoryType = item.done ? .checkmark : .none
        }
        else {
            cell.textLabel?.text = "No Todos Added"
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return todoItems?.count ?? 1
        
    }
    
    // MARK: - TableView Delegate Methods
        // this method is called whenever a row is selected
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let item = todoItems?[indexPath.row] {
            do {
                try realm.write {
                    item.done = !item.done
                }
            }
            catch {
                print("Error updating on Realm: \(error)")
            }
        }
        
        tableView.reloadData()
        
        // code for deleting item
        // watch this YouTube video to implement 'swipe to delete' functionality:
        // https://www.youtube.com/watch?v=wUVfE8cY2Hw
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
            
            if let currentCategory = self.selectedCategory {
                do {
                    try self.realm.write {
                        let newItem = Item()
                        newItem.title = textField.text!
                        newItem.dateCreated = Date()
                        currentCategory.items.append(newItem)
                    }
                }
                catch {
                    print("Error saving to Realm: \(error)")
                }
            }
            
            // reload data in tableView
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
    
    // MARK: - Model Manipulation Methods
    func loadItems() {

        todoItems = selectedCategory?.items.sorted(byKeyPath: "dateCreated", ascending: false)
            
        // TODO: - reload data in tableView
        tableView.reloadData()

    }
    
    // MARK: - Delete Data with Swipe
    override func updateModel(at indexPath: IndexPath) {
        if let swipedItem = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(swipedItem)
                }
            }
            catch {
                print("Error deleting item from Realm: \(error)")
            }
        }
    }

}


// MARK: - Search Bar Delegate Methods
extension TodoListViewController: UISearchBarDelegate {

    // triggered when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // use filter and sort methods in realm to filter and sort todoItems
        todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: false)
        
        // reload tableView
        tableView.reloadData()

    }

    // triggered when text in searchbar changes
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {

        // if searchBar is empty
        if searchBar.text?.count == 0 {
            // fetch all items
            loadItems()

            // dismiss keyboard and searchBar cursor on main thread
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        }

    }

}
