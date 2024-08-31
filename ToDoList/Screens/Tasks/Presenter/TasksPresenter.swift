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
}

protocol ITasksPresenter {
    func viewDidLoad()
    func didTapAddButton()
    func sectionIds() -> [ToDoSection]
    func cellIds(section: ToDoSection) -> [ToDoCellType]
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
            router.openTaskDetail(delegate: self)
        }
    }
}

extension TasksPresenter: TaskDetailsDelegate {
    
    func didCreateNewTask(name: String, description: String?) {
        interactor.handleNewTask(name: name, description: description)
    }
}

extension TasksPresenter: ITasksInteractorOutput {
    
    func didFetchTodos(models: [ToDoModel]) {
        let newViewModels = models.map {
            ToDoViewModel(
                id: $0.id,
                name: $0.todo,
                description: $0.todo,
                created: $0.dateOfCreation,
                completed: $0.completed
            )
        }
        
        let viewModels = toDoSectionCells.map {
            switch $0 {
            case let .main(model): return model
            }
        } + newViewModels
        
        let sortedModels = viewModels.sorted(by: { $0.id < $1.id && $0.completed || $1.completed })
        toDoSectionCells = sortedModels.map { ToDoCellType.main($0) }
        mainQueue.runOnMain { [weak view] in
            view?.stopLoader()
            view?.reloadView()
        }
    }
}
