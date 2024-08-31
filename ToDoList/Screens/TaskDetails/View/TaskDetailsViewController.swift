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
    private let verticalStackView = UIStackView()
    private let taskTextField = UITextField()
    private let descriptionTextField = UITextField()
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
        view.addSubview(verticalStackView)
        view.addSubview(completedButton)
        verticalStackView.addArrangedSubview(taskTextField)
        verticalStackView.addArrangedSubview(descriptionTextField)
        
        let placeholderAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor(resource: .text).withAlphaComponent(0.5),
            .font: Font.avenir(weight: .medium, size: 25)
        ]
    
        taskTextField.attributedPlaceholder = NSAttributedString(string: "New task", attributes: placeholderAttributes)
        descriptionTextField.attributedPlaceholder = NSAttributedString(string: "Task description", attributes: placeholderAttributes)
        
        for textField in [taskTextField, descriptionTextField] {
            textField.textColor = UIColor(resource: .text)
            textField.font = Font.avenir(weight: .medium, size: 25)
            textField.clearButtonMode = .whileEditing
            textField.layer.cornerRadius = 10
            textField.backgroundColor = UIColor(resource: .colorView)
            let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 15, height: taskTextField.frame.height))
            textField.leftView = paddingView
            textField.leftViewMode = .always
        }
        
        verticalStackView.axis = .vertical
        verticalStackView.spacing = 20
        verticalStackView.snp.makeConstraints { maker in
            maker.width.equalToSuperview().inset(32)
            maker.centerX.equalToSuperview()
            maker.bottom.equalTo(completedButton.snp.top).inset(-40)
        }
        
        completedButton.backgroundColor = UIColor(resource: .colorView)
        completedButton.layer.cornerRadius = 20
        completedButton.setTitle("Save", for: .normal)
        completedButton.titleLabel?.font = Font.avenir(weight: .medium, size: 25)
        completedButton.setTitleColor(UIColor(resource: .text), for: .normal)
        completedButton.addTarget(self, action: #selector(tapButton), for: .touchUpInside)
        completedButton.snp.makeConstraints { maker in
            maker.center.equalToSuperview()
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
        switch presenter.mode {
        case .edit:
            navigationItem.title = "Edit Task"
        case .new:
            navigationItem.title = "New Task"
        }
    }
}
