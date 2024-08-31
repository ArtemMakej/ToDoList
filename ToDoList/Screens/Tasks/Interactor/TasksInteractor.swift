//
//  TasksInteractor.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

protocol ITasksInteractor {
    func loadRemoteTodos()
    func handleNewTask(name: String, description: String?)
}

protocol ITasksInteractorOutput: AnyObject {
    func didFetchTodos(models: [ToDoModel])
}

final class TasksInteractor: ITasksInteractor {
    private static let hasFetchedTodosKey = "tasks.fetched"
    
    weak var output: ITasksInteractorOutput?
    
    private var maxId: Int = 0
    private let remoteTodosService: IRemoteTodosService
    private let userDefaults: IUserDefaults
    private let tasksStorageService: ITasksStorageService
    private let dateFormatter: DateFormatter
    
    init(
        remoteTodosService: IRemoteTodosService,
        userDefaults: IUserDefaults,
        tasksStorageService: ITasksStorageService,
        dateFormatter: DateFormatter
    ) {
        self.userDefaults = userDefaults
        self.remoteTodosService = remoteTodosService
        self.tasksStorageService = tasksStorageService
        self.dateFormatter = dateFormatter
    }
    
    func loadRemoteTodos() {
        tasksStorageService.loadModels { [weak self] loadedModels in
            guard let self else { return }
            let hasFetchedTodos = false // userDefaults.bool(forKey: Self.hasFetchedTodosKey)
            let id = loadedModels.map { $0.id }.max() ?? .zero
            maxId = id
            
            guard !hasFetchedTodos else {
                output?.didFetchTodos(models: loadedModels)
                return
            }
            loadTodosFromRemote(loadedModels: loadedModels)
        }
    }
    
    func handleNewTask(name: String, description: String?) {
        maxId = maxId + 1
        let now = Date()
        let dateOfCreation = dateFormatter.string(from: now)
        let model = ToDoModel(
            todo: name,
            description: description,
            dateOfCreation: dateOfCreation,
            completed: false,
            id: maxId
        )
        tasksStorageService.save(tasks: [model])
        output?.didFetchTodos(models: [model])
    }
    
    private func loadTodosFromRemote(loadedModels: [ToDoModel]) {
        remoteTodosService.loadTodos { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(models):
                let composedModels = loadedModels + models
                let maxId = composedModels.map { $0.id }.max()
                self.maxId = maxId ?? .zero
                
//                userDefaults.set(
//                    value: true,
//                    forKey: Self.hasFetchedTodosKey)
                tasksStorageService.save(tasks: models)
                output?.didFetchTodos(models: models)
            case let .failure(error):
                output?.didFetchTodos(models: loadedModels)
            }
        }
    }
}
