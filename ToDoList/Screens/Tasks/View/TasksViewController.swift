//
//  TasksViewController.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit
import SnapKit

// MARK: - ITasksViewController

protocol ITasksView: AnyObject {
    func reloadView()
    func startLoader()
    func stopLoader()
}

final class TasksViewController: UICollectionViewController {
    
    typealias DataSource = UICollectionViewDiffableDataSource<ToDoSection, ToDoCellType>
    typealias Snapshot = NSDiffableDataSourceSnapshot<ToDoSection, ToDoCellType>
    
    private let presenter: ITasksPresenter
    private let loaderView = UIActivityIndicatorView(style: .large)
    private var dataSource: DataSource?
    
    init(presenter: ITasksPresenter) {
        self.presenter = presenter
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        super.init(collectionViewLayout: flowLayout)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        setupViews()
        setupNavigationItem()
        setupNavigation()
        setupDataSource()
        presenter.viewDidLoad()
    }
    
    private func setupViews() {
        view.backgroundColor = UIColor(resource: .colorSet)
        collectionView.backgroundColor = UIColor(resource: .colorSet)
        collectionView.snp.makeConstraints { maker in
            maker.top.equalTo(view.safeAreaLayoutGuide.snp.top).inset(15)
            maker.left.equalToSuperview()
            maker.right.equalToSuperview()
            maker.bottom.equalTo(view.snp.bottom)
        }
        
        view.addSubview(loaderView)
        loaderView.snp.makeConstraints { maker in
            maker.center.equalTo(collectionView)
        }
    }
    
    private func setupDataSource() {
        let toDoCellRegistrator = UICollectionView.CellRegistration<ToDoCell, ToDoViewModel>
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
    
    private func setupNavigationItem() {
        guard let navigationController = navigationController else { return }
        let navigationTitleColor = UIColor(resource: .navigation)
        let titleFont = Font.avenir(weight: .bold, size: 35)
        navigationItem.title = "Todo List"
        navigationController.navigationBar.largeTitleTextAttributes = [
            .foregroundColor: navigationTitleColor,
            .font: titleFont
        ]
    }
    
    private func setupNavigation() {
        let plusButton = UIBarButtonItem(
            image: UIImage(systemName: "plus.circle.fill"),
            style: .plain,
            target: self,
            action: #selector(tapPlusBarButtonItem)
        )
        navigationItem.rightBarButtonItem = plusButton
        plusButton.tintColor = UIColor(resource: .navigation)
    }
}

// MARK: - ITasksView

extension TasksViewController: ITasksView {
    
    func reloadView() {
        dataSource?.apply(makeSnapshot())
    }
    
    func startLoader() {
        loaderView.startAnimating()
    }
    
    func stopLoader() {
        loaderView.stopAnimating()
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
