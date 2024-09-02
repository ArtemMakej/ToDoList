//
//  ToDoEntity+CoreDataProperties.swift
//  
//
//  Created by Artem Mackei on 02.09.2024.
//
//

import Foundation
import CoreData


extension ToDoEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ToDoEntity> {
        return NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
    }

    @NSManaged public var todoName: String
    @NSManaged public var isCompleted: Bool
    @NSManaged public var todoDescription: String?
    @NSManaged public var id: Int32
    @NSManaged public var dateOfCreation: String?

    func update(with model: ToDoModel) {
        todoName = model.todo
        isCompleted = model.completed
        todoDescription = model.description
        id = Int32(model.id)
        dateOfCreation = model.dateOfCreation
    }
}
