//
//  Categories+CoreDataProperties.swift
//  ToDoScheduling
//
//  Created by Oussama Ayed on 27/12/2017.
//  Copyright © 2017 Oussama Ayed. All rights reserved.
//
//

import Foundation
import CoreData


extension Categories {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Categories> {
        return NSFetchRequest<Categories>(entityName: "Categories")
    }

    @NSManaged public var name: String?
    @NSManaged public var categoryColor: String?

}
