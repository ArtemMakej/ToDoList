//
//  TasksStorageService.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

protocol ITasksStorageService {
    func loadModels(completion: @escaping (([ToDoModel]) -> Void))
    func save(tasks: [ToDoModel])
    func deleteTodo(at id: Int)
    func updateTodo(at id: Int, with: ToDoModel)
    
    // Saves to persistent store
    func saveToDisk()
}

final class TasksStorageService: ITasksStorageService {
    
    private let coreDataStorage: CoreDataStorage
    // Serial private queue
    private let privateQueue = DispatchQueue(label: "tasks.storage")
    
    init(storageService: CoreDataStorage) {
        self.coreDataStorage = storageService
    }
    
    func save(tasks: [ToDoModel]) {
        privateQueue.async { [weak self] in
            guard let self else { return }
            let existingTodoEntities = fetchTodos()
            let newSet: Set<ToDoModel> = Set(tasks)
            let existingSet: Set<ToDoModel> = Set(transformToDo(entities: existingTodoEntities))
            
            // Update tasks
            for entity in existingTodoEntities {
                let task = tasks.first(where: { $0.id == Int(entity.id) } )
                guard let task else { return }
                entity.update(with: task)
            }
            
            // Create new tasks
            let newItems = newSet.subtracting(existingSet)
            createNewTodos(tasks: Array(newItems))
        }
    }
    
    func deleteTodo(at id: Int) {
        privateQueue.async { [weak self] in
            guard let self else { return }
            let request = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            do {
                if let object = try coreDataStorage.context.fetch(request).first {
                    coreDataStorage.context.delete(object)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func updateTodo(at id: Int, with: ToDoModel) {
        privateQueue.async { [weak self] in
            guard let self else { return }
            let request = ToDoEntity.fetchRequest()
            request.predicate = NSPredicate(format: "id == %d", id)
            do {
                if let object = try coreDataStorage.context.fetch(request).first {
                    object.update(with: with)
                }
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    func loadModels(completion: @escaping (([ToDoModel]) -> Void)) {
        privateQueue.async { [weak self] in
            guard let self else { return }
            let result = fetchTodos()
            completion(transformToDo(entities: result))
        }
    }
    
    func saveToDisk() {
        coreDataStorage.context.perform { [weak self] in
            guard let self else { return }
            do {
                try coreDataStorage.context.save()
            } catch {
                assertionFailure(error.localizedDescription)
            }
        }
    }
    
    private func fetchTodos() -> [ToDoEntity] {
        do {
            return try coreDataStorage.context.fetch(ToDoEntity.fetchRequest())
        } catch {
            assertionFailure(error.localizedDescription)
            return []
        }
    }
    
    private func createNewTodos(tasks: [ToDoModel]) {
        for task in tasks {
            let _ = ToDoEntity(context: coreDataStorage.context, todo: task)
        }
    }
    
    private func transformToDo(entities: [ToDoEntity]) -> [ToDoModel] {
        entities.map(ToDoModel.init)
    }
}
