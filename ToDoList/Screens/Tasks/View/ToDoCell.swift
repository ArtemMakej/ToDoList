//
//  ToDoCell.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import UIKit

protocol IConfigurable {
    associatedtype Item
    func configure(item: Item)
}

final class ToDoCell: UICollectionViewCell, IConfigurable {
    
    private let containerView = UIView()
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let completedSwitch = UISwitch()
    
    private var viewModel: ToDoViewModel?
    
    override func layoutSubviews() {
        super.layoutSubviews()
        containerView.layer.cornerRadius = 30
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.addSubview(containerView)
        contentView.clipsToBounds = true
        containerView.backgroundColor = UIColor(resource: .colorView)
        containerView.addSubview(nameLabel)
        containerView.addSubview(completedSwitch)
        contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.left.right.equalToSuperview().inset(16)
        }
        
        nameLabel.textColor =  UIColor(resource: .colorSet)
        nameLabel.font = Font.avenir(weight: .medium, size: 19)
        nameLabel.numberOfLines = .zero
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(containerView.snp.top).offset(20)
            maker.right.left.equalToSuperview().inset(16)
        }
        
        completedSwitch.backgroundColor = UIColor(resource: .colorSet)
        completedSwitch.layer.cornerRadius = 15
        completedSwitch.onTintColor = UIColor(resource: .switch)
        completedSwitch.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        completedSwitch.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.centerX.equalTo(nameLabel)
            maker.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(item: ToDoViewModel) {
        viewModel = item
        nameLabel.text = item.name
        completedSwitch.isOn = item.completed
        let color = UIColor(resource: .colorView)
        containerView.backgroundColor = item.completed ? color.withAlphaComponent(0.5) : color
    }
    
    @objc private func didTapSwitch() {
        viewModel?.onToggle()
    }
}
