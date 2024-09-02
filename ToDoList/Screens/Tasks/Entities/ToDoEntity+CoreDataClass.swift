//
//  ToDoEntity+CoreDataClass.swift
//  
//
//  Created by Artem Mackei on 02.09.2024.
//
//

import Foundation
import CoreData

@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject {
    
    convenience init(context: NSManagedObjectContext, todo: ToDoModel) {
        self.init(context: context)
        self.id = Int32(todo.id)
        self.todoName = todo.todo
        self.todoDescription = todo.description
        self.isCompleted = todo.completed
        self.dateOfCreation = todo.dateOfCreation
    }
}
