//
//  NewTaskScreenPresenter.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

// MARK: - INewTaskScreenPresenter

protocol INewTaskScreenPresenter {
}

final class NewTaskScreenPresenter: INewTaskScreenPresenter {
    
    weak var view: NewTaskScreenViewController?
    weak var delegate: NewTaskDelegate?
    
    func didTapCreateNewTask(text: String?) {
        guard let text, !text.isEmpty else { return }
        let model = ToDoModel(
            id: Int.random(in: 1...10),
            todo: text,
            completed: false,
            userId: 123
        )
        delegate?.didCreateNewTask(model: model)
        view?.close()
    }
}
