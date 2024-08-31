//
//  TaskDetailsViewController.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

// MARK: - ITaskDetailsViewController

protocol ITaskDetailsView: AnyObject { }

class TaskDetailsViewController: UIViewController {
    
    private let presenter: TaskDetailsPresenter
    private let taskTextField = UITextField()
    private let completedButton = UIButton()
    
    init(presenter: TaskDetailsPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(resource: .colorSet)
        setupNavigationItem()
        setupViews()
    }
}

extension TaskDetailsViewController: ITaskDetailsView {

}

extension TaskDetailsViewController {
    private func setupViews() {
        view.addSubview(taskTextField)
        view.addSubview(completedButton)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .text),
            .font: Font.avenir(weight: .medium, size: 25)
        ]
        let attributedPlaceholder = NSAttributedString(string: "Create a new task", attributes: placeholderAttributes)
        taskTextField.attributedPlaceholder = attributedPlaceholder
        taskTextField.textColor = UIColor(resource: .text)
        taskTextField.font = Font.avenir(weight: .medium, size: 25)
        taskTextField.clearButtonMode = .whileEditing
        taskTextField.layer.cornerRadius = 10
        taskTextField.backgroundColor = UIColor(resource: .colorView)
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: taskTextField.frame.height))
        taskTextField.leftView = paddingView
        taskTextField.leftViewMode = .always
        taskTextField.snp.makeConstraints { maker in
            //maker.top.equalTo(view.safeAreaLayoutGuide).inset(50)
            maker.center.equalToSuperview().offset(-75)
            maker.right.left.equalToSuperview().inset(17)
            maker.height.equalTo(40)
        }
        
        completedButton.backgroundColor = UIColor(resource: .colorView)
        completedButton.layer.cornerRadius = 20
        completedButton.setTitle("Save", for: .normal)
        completedButton.titleLabel?.font = Font.avenir(weight: .medium, size: 25)
        completedButton.setTitleColor(UIColor(resource: .text), for: .normal)
        completedButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        completedButton.snp.makeConstraints { maker in
            maker.top.equalTo(taskTextField.snp.bottom).offset(70)
            //maker.bottom.equalToSuperview().inset(50)
            maker.centerX.equalTo(taskTextField)
            maker.height.equalTo(55)
            maker.width.equalTo(205)
        }
    }
    
    @objc func tapButton() {
        presenter.didTapCreateNewTask(name: taskTextField.text, description: nil)
    }
}

extension TaskDetailsViewController {
    private func setupNavigationItem() {
        let navigationTitleColor = UIColor(resource: .navigation)
        navigationController?.navigationBar.titleTextAttributes = [
            .foregroundColor: navigationTitleColor
        ]
        navigationController?.navigationBar.tintColor = navigationTitleColor
    }
}
