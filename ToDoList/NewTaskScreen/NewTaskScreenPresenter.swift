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
    
}
