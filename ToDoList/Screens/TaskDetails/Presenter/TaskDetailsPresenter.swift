//
//  TaskDetailsPresenter.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

// MARK: - ITaskDetailsPresenter

protocol ITaskDetailsPresenter {
    func didTapCreateNewTask(name: String?, description: String?)
}

final class TaskDetailsPresenter: ITaskDetailsPresenter {
    
    weak var view: TaskDetailsViewController?
    weak var delegate: TaskDetailsDelegate?
    
    private let interactor: ITaskDetailsInteractor
    private let router: ITaskDetailsRouter
    private let mainQueue: IMainQueue
    
    init(
        interactor: ITaskDetailsInteractor,
        router: ITaskDetailsRouter,
        mainQueue: IMainQueue
    ) {
        self.interactor = interactor
        self.router = router
        self.mainQueue = mainQueue
    }
    
    func didTapCreateNewTask(name: String?, description: String?) {
        guard let name, !name.isEmpty else { return }
        delegate?.didCreateNewTask(name: name, description: description)
        mainQueue.runOnMain { [weak self] in
            self?.router.close()
        }
    }
}
