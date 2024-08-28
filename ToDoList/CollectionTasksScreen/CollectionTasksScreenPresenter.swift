//
//  CollectionTasksScreenPresenter.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

// MARK: - ICollectionTasksScreenPresenter

protocol ICollectionTasksScreenPresenter {
    func viewDidLoad()
}

final class CollectionTasksScreenPresenter: ICollectionTasksScreenPresenter {
    
    weak var view: ICollectionTasksScreenViewController?
    
    func viewDidLoad() {
        //
    }
    
}
