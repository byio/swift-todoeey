//
//  Category.swift
//  Todoeey
//
//  Created by BenYang on 3/5/19.
//  Copyright © 2019 BenYang. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
    
    @objc dynamic var name: String = ""
    
    // forward relationship with Item
    /*
        This means that inside each Category, there's a thing called items
        that points that a List of Item
    */
    let items = List<Item>()
    
}
