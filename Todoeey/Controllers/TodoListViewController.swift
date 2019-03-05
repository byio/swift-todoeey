//
//  ViewController.swift
//  Todoeey
//
//  Created by BenYang on 2/26/19.
//  Copyright © 2019 BenYang. All rights reserved.


import UIKit
import CoreData

class TodoListViewController: UITableViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    
    // define persistent context
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // initialize itemArray as an Array of Item objects
    var itemArray = [Item]()
    
    // property that interfaces with CategoryViewController
    var selectedCategory: Category? {
        // code below triggers once optional variable is set
        didSet {
            
            // load data from CoreData
            loadItems()
            
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        searchBar.delegate = self
        
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
        
        // code for deleting item
        // watch this YouTube video to implement 'swipe to delete' functionality:
        // https://www.youtube.com/watch?v=wUVfE8cY2Hw
//        context.delete(itemArray[indexPath.row])
//        itemArray.remove(at: indexPath.row)
        
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
            
            // append item to itemArray
            let newItem = Item(context: self.context)
            newItem.title = textField.text!
            newItem.done = false
            newItem.category = self.selectedCategory
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
        
        do {
            try context.save()
        }
        catch {
            print("Error saving context \(error)")
        }
        
        // TODO: - reload data in tableView
        tableView.reloadData()
    }
    
    func loadItems(with request: NSFetchRequest<Item> = Item.fetchRequest(), predicate: NSPredicate? = nil) {
        
        // predicate to filter items by category
        let categoryPredicate = NSPredicate(format: "category.name MATCHES %@", selectedCategory!.name!)
        
        // conditionally create compount predicate
        if let additionalPredicate = predicate {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [categoryPredicate, additionalPredicate])
        }
        else {
            request.predicate = categoryPredicate
        }
        
        // carry out fetch via context
        do {
            // this method returns an NSFetchResult which is [Item]
            itemArray = try context.fetch(request)
        }
        catch {
            print("Error fetching data from context \(error)")
        }
        
        // TODO: - reload data in tableView
        tableView.reloadData()
        
    }

}

// MARK: - Search Bar Delegate Methods
extension TodoListViewController: UISearchBarDelegate {
    
    // triggered when search button is clicked
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // create fetch request
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        // create core data query using NSPredicate and add to request
        let searchPredicate = NSPredicate(format: "title CONTAINS[cd] %@", searchBar.text!)
        
        // specify rule to sort results and add to request
        request.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)]
        
        // fetch based on query
        loadItems(with: request, predicate: searchPredicate)
        
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
