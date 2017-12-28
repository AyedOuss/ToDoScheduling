//
//  Tasks+CoreDataProperties.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 27/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//
//

import Foundation
import CoreData


extension Tasks {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Tasks> {
        return NSFetchRequest<Tasks>(entityName: "Tasks")
    }

    @NSManaged public var title: String?
    @NSManaged public var category: String?
    @NSManaged public var taskDate: NSDate?

}
