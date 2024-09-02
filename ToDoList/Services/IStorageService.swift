//
//  IStorageService.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation
import CoreData

protocol IStorageService {
    
}

final class CoreDataStorage: IStorageService {
    
    let container: NSPersistentContainer
    // Runs on private queue & not main queue
    let context: NSManagedObjectContext
    
    deinit {
        do { if context.hasChanges { try context.save() } }
        catch { assertionFailure(error.localizedDescription) }
    }
    
    init() {
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores { _, error in }
        context = container.newBackgroundContext()
    }
}
