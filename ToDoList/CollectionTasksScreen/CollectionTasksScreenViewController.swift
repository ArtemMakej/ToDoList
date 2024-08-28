//
//  CollectionTasksScreenViewController.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit
import SnapKit

// MARK: - ICollectionTasksScreenViewController

protocol ICollectionTasksScreenViewController: AnyObject {
    
}

final class CollectionTasksScreenViewController: UICollectionViewController {
    
    private let presenter: ICollectionTasksScreenPresenter
    
    init(presenter: ICollectionTasksScreenPresenter) {
        self.presenter = presenter
        let flowLayout = UICollectionViewFlowLayout()
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    override func viewDidLoad() {
        collectionView.backgroundColor = UIColor(resource: .colorSet)
       
        
        
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.left.equalToSuperview()
        }
        setupNavigationItem()
        setupNavigation()
    }
    
    
    private func setupNavigationItem() {
        guard let navigationController = navigationController else {
                return
            }
        let navigationTitleColor = UIColor(resource: .navigation)
       let titleFont = Font.avenir(weight: .bold, size: 35)
        navigationController.navigationBar.largeTitleTextAttributes = [
                .foregroundColor: navigationTitleColor,
                .font: titleFont
            ]
        navigationItem.title = "Список задач"
    }
    
    
    private func setupNavigation() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(tapPlusBarButtonItem))
        navigationItem.rightBarButtonItem = plusButton
        plusButton.tintColor = UIColor(resource: .navigation)
    }
    
    @objc private func tapPlusBarButtonItem() {
        let  newTasksScreenViewController = NewTaskScreenAssembly().assemble()
        navigationController?.pushViewController(newTasksScreenViewController, animated: true)
    }
}

extension CollectionTasksScreenViewController: ICollectionTasksScreenViewController {
    
}
