//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import UIKit

protocol ITasksRouter {
    func openTaskDetail(delegate: TaskDetailsDelegate)
}

final class TasksRouter: ITasksRouter {
    
    weak var controller: UIViewController?
    
    func openTaskDetail(delegate: TaskDetailsDelegate) {
        let newTasksScreenViewController = TaskDetailsAssembly().assemble(delegate: delegate)
        controller?.navigationController?.pushViewController(newTasksScreenViewController, animated: true)
    }
}
