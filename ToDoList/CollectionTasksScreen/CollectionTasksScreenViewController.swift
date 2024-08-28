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
        collectionView.backgroundColor = .white
        navigationItem.title = "Список задач"
        
        collectionView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.right.left.equalToSuperview()
        }
        setupNavigationItem()
    }
    
    private func setupNavigationItem() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(tapPlusBarButtonItem))
        navigationItem.rightBarButtonItem = plusButton
        plusButton.tintColor = .black
    }
    
    @objc private func tapPlusBarButtonItem() {
        let  newTasksScreenViewController = NewTaskScreenAssembly().assemble()
        navigationController?.pushViewController(newTasksScreenViewController, animated: true)
    }
}

extension CollectionTasksScreenViewController: ICollectionTasksScreenViewController {
    
}
