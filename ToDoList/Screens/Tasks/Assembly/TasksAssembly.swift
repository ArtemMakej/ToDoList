//
//  TasksAssembly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - ITasksAssembly

protocol ITasksAssembly {
    func assemble() -> UIViewController
}

final class TasksAssembly: ITasksAssembly {
    func assemble() -> UIViewController {
        let remoteTodosService = RemoteTodosService(network: URLSession.shared)
        let tasksStorageService = TasksStorageService(storageService: CoreDataStorage())
        
        let router = TasksRouter()
        
        let interactor = TasksInteractor(
            remoteTodosService: remoteTodosService,
            userDefaults: UserDefaults.standard,
            tasksStorageService: tasksStorageService,
            dateFormatter: .shortRuFormmater,
            willTerminateNotificationName: UIApplication.willTerminateNotification,
            willEnterBackgroundNotificationName: UIApplication.didEnterBackgroundNotification
        )
        
        let presenter = TasksPresenter(
            mainQueue: DispatchQueue.main,
            interactor: interactor,
            router: router
        )
        let viewController = TasksViewController(presenter: presenter)
        presenter.view = viewController
        interactor.output = presenter
        router.controller = viewController
        return viewController
    }
}
