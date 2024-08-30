//
//  ToDoListItem+CoreDataProperties.swift
//  
//
//  Created by Artem Mackei on 29.08.2024.
//
//

import Foundation
import CoreData


extension ToDoListItem {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoListItem> {
        return NSFetchRequest<ToDoListItem>(entityName: "ToDoListItem")
    }

    @NSManaged public var name: String?
}
