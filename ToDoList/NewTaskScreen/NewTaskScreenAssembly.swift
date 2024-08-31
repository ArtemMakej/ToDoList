//
//  NewTaskScreenAssembly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - INewTaskScreenAssembly

protocol INewTaskScreenAssembly {
    func assemble(delegate: NewTaskDelegate) -> UIViewController
}

final class NewTaskScreenAssembly: INewTaskScreenAssembly {
    func assemble(delegate: NewTaskDelegate) -> UIViewController {
        let presenter = NewTaskScreenPresenter()
        let vc = NewTaskScreenViewController(presenter: presenter)
        presenter.view = vc
        presenter.delegate = delegate
        return vc
    }
}
