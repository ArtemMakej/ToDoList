//
//  NewTaskScreenViewController.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - INewTaskScreenViewController

protocol INewTaskScreenViewController: AnyObject {
}

class NewTaskScreenViewController: UIViewController {
    
    private let presenter: NewTaskScreenPresenter
    
    init(presenter: NewTaskScreenPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
    }
}

extension NewTaskScreenViewController: INewTaskScreenViewController {
    
}
