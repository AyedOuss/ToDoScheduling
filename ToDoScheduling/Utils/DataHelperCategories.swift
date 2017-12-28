//
//  DataHelperCategories.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 27/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//

import Foundation
import CoreData
class DataHelperCategories {
    let categories = ["Ruby", "iOS", "Android", "J2EE"]
    let colors = ["#DF0A16", "#FF7C4C", "#207068", "#1B75BB"]
    
    let context: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.context = context
    }
    internal func seedCategories() {
        
        for i in 0 ..< categories.count{
            let category = NSEntityDescription.insertNewObject(forEntityName: "Categories", into: context) as! Categories
            category.name = categories[i] as String
            category.categoryColor = colors[i] as String
        }
        do {
            try context.save()
        } catch _ {}
    }
    
    
}

