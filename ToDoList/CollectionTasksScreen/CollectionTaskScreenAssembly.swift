//
//  CollectionTaskScreenAssembly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - ICollectionTaskScreenAssembly

protocol ICollectionTaskScreenAssembly {
    func assemble() -> UIViewController
}

final class CollectionTaskScreenAssembly: ICollectionTaskScreenAssembly {
    func assemble() -> UIViewController {
        let presenter = CollectionTasksScreenPresenter()
        let vc = CollectionTasksScreenViewController(presenter: presenter)
        presenter.view = vc
        return vc
    }
}
