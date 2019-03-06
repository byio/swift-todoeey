//
//  Item.swift
//  Todoeey
//
//  Created by BenYang on 3/5/19.
//  Copyright © 2019 BenYang. All rights reserved.
//

import Foundation
import RealmSwift

class Item: Object {
    @objc dynamic var title: String = ""
    @objc dynamic var done: Bool = false
    @objc dynamic var dateCreated: Date?
    
    // inverse relationship with Category
    /*
        Category.self = type
        property refers to the relationship property in Item class, which is
        items
    */
    var category = LinkingObjects(fromType: Category.self, property: "items")
}
