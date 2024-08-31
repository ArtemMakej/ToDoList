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
    func reloadView()
    func openNewTaskScreen(delegate: NewTaskDelegate)
}

final class CollectionTasksScreenViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<ToDoSection, ToDoCellType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ToDoSection, ToDoCellType>
    
    private let presenter: ICollectionTasksScreenPresenter
    private var dataSource: DataSource?
    
    init(presenter: ICollectionTasksScreenPresenter) {
        self.presenter = presenter
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        view.backgroundColor = UIColor(resource: .colorSet)
        collectionView.backgroundColor = UIColor(resource: .colorSet)
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottom)
        }
        
        setupNavigationItem()
        setupNavigation()
        setupDataSource()
        presenter.viewDidLoad()
    }
    
    private func setupDataSource() {
        let toDoCellRegistrator = UICollectionView.CellRegistration<ToDoCell, ToDoModel>
        { [weak self] cell, IndexPath, itemIdentifier in
            guard let self else { return }
            cell.contentView.snp.makeConstraints { maker in
                maker.width.equalTo(self.collectionView.frame.width - (16 * 2))
            }
            cell.configure(item: itemIdentifier) }
        let dataSource = DataSource(collectionView: collectionView)
        { collectionView, indexPath, itemIdentifier in
            switch indexPath.section {
            case ToDoSection.main.rawValue:
                switch itemIdentifier {
                case let .main(item):
                    return collectionView.dequeueConfiguredReusableCell(using: toDoCellRegistrator, for: indexPath, item: item)
                }
            default:
                return nil
            }
        }
        collectionView.dataSource = dataSource
        self.dataSource = dataSource
    }
    
    @objc private func tapPlusBarButtonItem() {
        presenter.didTapAddButton()
    }
}

extension CollectionTasksScreenViewController: ICollectionTasksScreenViewController {
    
    func reloadView() {
        dataSource?.apply(makeSnapshot())
    }
    
    func openNewTaskScreen(delegate: NewTaskDelegate) {
        let  newTasksScreenViewController = NewTaskScreenAssembly().assemble(delegate: delegate)
        navigationController?.pushViewController(newTasksScreenViewController, animated: true)
    }
    
    private func makeSnapshot() -> Snapshot {
        var snaphot = Snapshot()
        let sections = presenter.sectionIds()
        snaphot.appendSections(sections)
        for section in sections {
            let cells = presenter.cellIds(section: section)
            snaphot.appendItems(cells, toSection: section)
        }
        return snaphot
    }
}

extension CollectionTasksScreenViewController {
    func setupNavigationItem() {
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
    
    func setupNavigation() {
        let plusButton = UIBarButtonItem(image: UIImage(systemName: "plus.circle.fill"), style: .plain, target: self, action: #selector(tapPlusBarButtonItem))
        navigationItem.rightBarButtonItem = plusButton
        plusButton.tintColor = UIColor(resource: .navigation)
    }
}
