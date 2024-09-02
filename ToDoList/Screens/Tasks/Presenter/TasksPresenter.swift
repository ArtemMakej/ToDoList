//
//  TasksPresenter.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

// MARK: - ITasksPresenter

protocol TaskDetailsDelegate: AnyObject {
    func didCreateNewTask(name: String, description: String?)
    func didUpdateTask(model: ToDoModel)
}

protocol ITasksPresenter {
    func viewDidLoad()
    func didTapAddButton()
    func sectionIds() -> [ToDoSection]
    func cellIds(section: ToDoSection) -> [ToDoCellType]
    func swipedEditTask(indexPath: IndexPath)
    func swipedDeleteTask(indexPath: IndexPath)
}

final class TasksPresenter: ITasksPresenter {
    
    weak var view: ITasksView?
    
    private let mainQueue: IMainQueue
    private let interactor: ITasksInteractor
    private let router: ITasksRouter
    
    private var sections: [ToDoSection] = [.main]
    private var toDoSectionCells: [ToDoCellType] = []
    
    init(
        mainQueue: IMainQueue,
        interactor: ITasksInteractor,
        router: ITasksRouter
    ) {
        self.mainQueue = mainQueue
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        mainQueue.runOnMain { [weak view] in view?.startLoader() }
        interactor.loadRemoteTodos()
    }
    
    func sectionIds() -> [ToDoSection] {
        sections
    }
    
    func cellIds(section: ToDoSection) -> [ToDoCellType] {
        switch section {
        case .main:
            return toDoSectionCells
        }
    }
    
    func didTapAddButton() {
        mainQueue.runOnMain { [weak self] in
            guard let self else { return }
            router.openNewTask(delegate: self)
        }
    }
    
    func swipedEditTask(indexPath: IndexPath) {
        guard let taskModel = interactor.findModel(index: indexPath.item) else { return }
        mainQueue.runOnMain { [weak self] in
            guard let self else { return }
            router.openEditTask(task: taskModel, delegate: self)
        }
    }
    
    func swipedDeleteTask(indexPath: IndexPath) {
        interactor.deleteTask(index: indexPath.item)
    }
}

extension TasksPresenter: TaskDetailsDelegate {
    
    func didCreateNewTask(name: String, description: String?) {
        interactor.handleNewTask(name: name, description: description)
    }
    
    func didUpdateTask(model: ToDoModel) {
        interactor.handleUpdatedTask(model: model)
    }
}

extension TasksPresenter: ITasksInteractorOutput {
    
    func didFetchTodos(models: [ToDoModel]) {
        let newViewModels = mapToViewModels(todoModels: models)
        toDoSectionCells = newViewModels.map { ToDoCellType.main($0) }
        mainQueue.runOnMain { [weak view] in
            view?.stopLoader()
            view?.reloadView()
        }
    }
    
    func didUpdateTodos(models: [ToDoModel]) {
        didFetchTodos(models: models)
    }
    
    private func mapToViewModels(todoModels: [ToDoModel]) -> [ToDoViewModel] {
        todoModels.map { model in
            ToDoViewModel(
                id: model.id,
                name: model.todo,
                description: model.description,
                created: model.dateOfCreation,
                completed: model.completed,
                onToggle: { [weak self] in
                    self?.interactor.toggleTodo(at: model.id)
                }
            )
        }
    }
}
