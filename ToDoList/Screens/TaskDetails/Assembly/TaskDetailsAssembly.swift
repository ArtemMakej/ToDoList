//
//  TaskDetailsAssembly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - ITaskDetailsAssembly

protocol ITaskDetailsAssembly {
    func assemble(editingTask: ToDoModel?, delegate: TaskDetailsDelegate) -> UIViewController
}

final class TaskDetailsAssembly: ITaskDetailsAssembly {
    func assemble(editingTask: ToDoModel?, delegate: TaskDetailsDelegate) -> UIViewController {
        let router = TaskDetailsRouter()
        let presenter = TaskDetailsPresenter(
            editingTask: editingTask,
            interactor: TaskDetailsInteractor(),
            router: router,
            mainQueue: DispatchQueue.main
        )
        let viewController = TaskDetailsViewController(presenter: presenter)
        presenter.view = viewController
        presenter.delegate = delegate
        router.controller = viewController
        return viewController
    }
}
