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
    func toggleTodo(at id: Int)
    func findModel(index: Int) -> ToDoModel?
    func deleteTask(index: Int)
}

protocol ITasksInteractorOutput: AnyObject {
    func didFetchTodos(models: [ToDoModel])
    func didUpdateTodos(models: [ToDoModel])
}

final class TasksInteractor: ITasksInteractor {
    private static let hasFetchedTodosKey = "tasks.fetched"
    
    weak var output: ITasksInteractorOutput?
    
    private let remoteTodosService: IRemoteTodosService
    private let userDefaults: IUserDefaults
    private let tasksStorageService: ITasksStorageService
    private let dateFormatter: DateFormatter
    
    // State
    private var maxId: Int = 0
    private var todoModels: [ToDoModel] = []
    
    deinit {
        tasksStorageService.save(tasks: todoModels)
    }
    
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
                self.todoModels = loadedModels
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
        todoModels = sort(todoModels: todoModels + [model])
        output?.didFetchTodos(models: todoModels)
    }
    
    func toggleTodo(at id: Int) {
        let foundModelIndex: Int? = todoModels.firstIndex(where: { $0.id == id})
        guard let foundModelIndex else { return }
        todoModels[foundModelIndex].completed = !todoModels[foundModelIndex].completed
        todoModels = sort(todoModels: todoModels)
        output?.didUpdateTodos(models: todoModels)
    }
    
    func findModel(index: Int) -> ToDoModel? {
        guard todoModels.indices.contains(index) else { return nil }
        return todoModels[index]
    }
    
    func deleteTask(index: Int) {
        todoModels.remove(at: index)
        output?.didUpdateTodos(models: todoModels)
    }
    
    private func loadTodosFromRemote(loadedModels: [ToDoModel]) {
        remoteTodosService.loadTodos { [weak self] result in
            guard let self else { return }
            switch result {
            case let .success(models):
                let composedModels = loadedModels + models
                let maxId = composedModels.map { $0.id }.max()
                self.maxId = maxId ?? .zero
                self.todoModels = sort(todoModels: composedModels)
                
                //                userDefaults.set(
                //                    value: true,
                //                    forKey: Self.hasFetchedTodosKey)
                output?.didFetchTodos(models: todoModels)
            case let .failure(error):
                self.todoModels = loadedModels
                output?.didFetchTodos(models: loadedModels)
            }
        }
    }
    
    private func sort(todoModels: [ToDoModel]) -> [ToDoModel] {
        todoModels.sorted {
            if $0.completed == $1.completed {
                return $0.id < $1.id
            }
            return !$0.completed && $1.completed
        }
    }
}
