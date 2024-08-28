//
//  RootAssambly.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - IRootAssembly

protocol IRootAssembly {
    func assemble() -> UIViewController
}

final class RootAssambly:  IRootAssembly {
    func assemble() -> UIViewController {
        let navigationController = UINavigationController(
            rootViewController: CollectionTaskScreenAssembly().assemble()
        )
        navigationController.navigationBar.prefersLargeTitles = true
        return navigationController
    }
}
