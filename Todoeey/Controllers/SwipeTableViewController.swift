//
//  SwipeTableViewController.swift
//  Todoeey
//
//  Created by BenYang on 3/7/19.
//  Copyright © 2019 BenYang. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - TableView DataSource Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // create reusable cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        
        // set SwipeTableViewController as cell delegate
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - SwipeTableViewCell Delegate Methods
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
        
        // checks that swipe action comes from the right
        guard orientation == .right else { return nil }
        
        // define delete action
        let deleteAction = SwipeAction(style: .destructive, title: "Delete") { (action, indexPath) in
            
            self.updateModel(at: indexPath)
            
        }
        
        // customize action appearance
        //        deleteAction.image = UIImage(named: "delete")
        
        return [deleteAction]
    }
    
    func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
        // create an instance of SwipeOptions
        var options = SwipeOptions()
        
        // modify options
        options.transitionStyle = .reveal
        options.expansionStyle = .destructive
        
        // return options
        return options
    }
    
    // MARK: - Data (Model) Manipulation Methods
    func updateModel(at indexPath: IndexPath) {
        
    }

}
