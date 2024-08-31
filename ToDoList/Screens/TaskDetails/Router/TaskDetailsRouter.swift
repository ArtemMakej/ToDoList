//
//  TaskDetailsRouter.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import UIKit

protocol ITaskDetailsRouter {
    func close()
}

final class TaskDetailsRouter: ITaskDetailsRouter {
    weak var controller: UIViewController?
    
    func close() {
        controller?.navigationController?.popViewController(animated: true)
    }
}
