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
}

final class TasksStorageService: ITasksStorageService {
    private let storageService: IStorageService
    
    init(storageService: IStorageService) {
        self.storageService = storageService
    }
    
    func save(tasks: [ToDoModel]) {
        
    }
    
    func loadModels(completion: @escaping (([ToDoModel]) -> Void)) {
        completion([])
    }
}
