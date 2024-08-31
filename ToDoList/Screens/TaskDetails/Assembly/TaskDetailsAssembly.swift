//
//  TaskDetailsAssembly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - ITaskDetailsAssembly

protocol ITaskDetailsAssembly {
    func assemble(delegate: TaskDetailsDelegate) -> UIViewController
}

final class TaskDetailsAssembly: ITaskDetailsAssembly {
    func assemble(delegate: TaskDetailsDelegate) -> UIViewController {
        let router = TaskDetailsRouter()
        let presenter = TaskDetailsPresenter(
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
