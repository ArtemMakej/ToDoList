//
//  TaskDetailsPresenter.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

// MARK: - ITaskDetailsPresenter

enum TaskDetailsMode {
    case new
    case edit
}

protocol ITaskDetailsPresenter {
    var mode: TaskDetailsMode { get }
    func didTapCreateNewTask(name: String?, description: String?)
}

final class TaskDetailsPresenter: ITaskDetailsPresenter {
    
    let mode: TaskDetailsMode
    
    weak var view: TaskDetailsViewController?
    weak var delegate: TaskDetailsDelegate?
    
    private let interactor: ITaskDetailsInteractor
    private let router: ITaskDetailsRouter
    private let mainQueue: IMainQueue
    private var editingTask: ToDoModel?
    
    init(
        editingTask: ToDoModel?,
        interactor: ITaskDetailsInteractor,
        router: ITaskDetailsRouter,
        mainQueue: IMainQueue
    ) {
        self.interactor = interactor
        self.router = router
        self.mainQueue = mainQueue
        self.mode = editingTask == nil ? .new : .edit
        self.editingTask = editingTask
    }
    
    func didTapCreateNewTask(name: String?, description: String?) {
        guard let name, !name.isEmpty else { return }
        delegate?.didCreateNewTask(name: name, description: description)
        mainQueue.runOnMain { [weak self] in
            self?.router.close()
        }
    }
}
