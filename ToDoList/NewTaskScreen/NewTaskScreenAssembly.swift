//
//  NewTaskScreenAssembly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - INewTaskScreenAssembly

protocol INewTaskScreenAssembly {
    func assemble() -> UIViewController
}

final class NewTaskScreenAssembly: INewTaskScreenAssembly {
    func assemble() -> UIViewController {
        let presenter = NewTaskScreenPresenter()
        let vc = NewTaskScreenViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
