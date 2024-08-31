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

protocol ICollectionTasksScreenPresenter {
    func viewDidLoad()
    func didTapAddButton()
    func sectionIds() -> [ToDoSection]
    func cellIds(section: ToDoSection) -> [ToDoCellType]
}

final class CollectionTasksScreenPresenter: ICollectionTasksScreenPresenter {
    
    weak var view: ICollectionTasksScreenViewController?
    private var sections: [ToDoSection] = [.main]
    private var toDoSectionCells: [ToDoCellType] = []
    
    func viewDidLoad() {
        loadingToDosModel()
    }
    
    func sectionIds() -> [ToDoSection] {
        sections
    }
    
    func didTapAddButton() {
        view?.openNewTaskScreen(delegate: self)
    }
    
    func cellIds(section: ToDoSection) -> [ToDoCellType] {
        switch section {
        case .main:
            return toDoSectionCells
        }
    }
    
    private func loadingToDosModel() {
        let urlRequest = "https://dummyjson.com/todos"
        guard let url = URL(string: urlRequest) else { return }
        URLSession.shared.dataTask(with: url) { (data, responce, error) in
            guard let data = data
            else { return }
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let result = try decoder.decode(ToDosWrapper.self, from: data)
                let mappedResult = result.todos.map { ToDoCellType.main($0) }
                self.toDoSectionCells.append(contentsOf: mappedResult)
                DispatchQueue.main.async {
                    self.view?.reloadView()
                }
            } catch let error {
                print("Error", error)
            }
        }.resume()
    }
}

extension CollectionTasksScreenPresenter: NewTaskDelegate {
    
    func didCreateNewTask(model: ToDoModel) {
        toDoSectionCells.append(.main(model))
        view?.reloadView()
    }
}
