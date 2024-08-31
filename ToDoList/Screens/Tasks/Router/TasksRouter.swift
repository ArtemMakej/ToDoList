//
//  TasksRouter.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import UIKit

protocol ITasksRouter {
    func openNewTask(delegate: TaskDetailsDelegate)
    func openEditTask(task: ToDoModel, delegate: TaskDetailsDelegate)
}

final class TasksRouter: ITasksRouter {
    
    weak var controller: UIViewController?
    
    func openNewTask(delegate: TaskDetailsDelegate) {
        let taskDetailViewController = TaskDetailsAssembly().assemble(editingTask: nil, delegate: delegate)
        controller?.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
    
    func openEditTask(task: ToDoModel, delegate: TaskDetailsDelegate) {
        let taskDetailViewController = TaskDetailsAssembly().assemble(editingTask: task, delegate: delegate)
        controller?.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
}
