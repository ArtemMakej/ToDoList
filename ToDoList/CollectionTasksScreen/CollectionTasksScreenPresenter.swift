//
//  CollectionTasksScreenPresenter.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

// MARK: - ICollectionTasksScreenPresenter

protocol NewTaskDelegate: AnyObject {
    func didCreateNewTask(model: ToDoModel)
}

enum ToDoSection: Int {
    case main
}

enum ToDoCellType: Hashable {
    case main(ToDoModel)
}

protocol ICollectionTasksScreenPresenter {
    func viewDidLoad()
    func sectionIds() -> [ToDoSection]
    func cellIds(section: ToDoSection) -> [ToDoCellType]
}

final class CollectionTasksScreenPresenter: ICollectionTasksScreenPresenter {
    
    weak var view: ICollectionTasksScreenViewController?
    private  var sections: [ToDoSection] = []
    private var toDoSectionCells: [ToDoCellType] = []
    
    init() {
        sections = [.main]
        var id = 1
        let names = ["Create a design for the app"]
        let model = ToDoModel(id: id, name: names.randomElement()!, completed: false, userId: 324)
        toDoSectionCells.append(.main(model))
        id = id + 1
    }
    
    func viewDidLoad() {
        view?.reloadView()
    }
    
    func sectionIds() -> [ToDoSection] {
        sections
    }
    
    func cellIds(section: ToDoSection) -> [ToDoCellType] {
        switch section {
        case .main:
            return toDoSectionCells
        }
    }
}

extension CollectionTasksScreenPresenter: NewTaskDelegate {
    
    func didCreateNewTask(model: ToDoModel) {
        toDoSectionCells.append(.main(model))
        view?.reloadView()
    }
}
