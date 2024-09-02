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
    private let createdDateLabel = UILabel()
    private let nameLabel = UILabel()
    private let descriptionLabel = UILabel()
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
        containerView.addSubview(createdDateLabel)
        containerView.addSubview(nameLabel)
        containerView.addSubview(descriptionLabel)
        containerView.addSubview(completedSwitch)
        contentView.snp.makeConstraints { maker in
            maker.edges.equalToSuperview()
        }
        
        containerView.snp.makeConstraints { maker in
            maker.top.bottom.equalToSuperview()
            maker.left.right.equalToSuperview().inset(16)
        }
        
        createdDateLabel.textColor = UIColor(resource: .colorSet)
        createdDateLabel.textAlignment = .right
        createdDateLabel.font = Font.avenir(weight: .regular, size: 16)
        createdDateLabel.snp.makeConstraints { maker in
            maker.top.equalTo(completedSwitch.snp.bottom).offset(5)
            maker.left.right.equalToSuperview().inset(20)
            maker.bottom.equalToSuperview().inset(20)
        }
        
        nameLabel.textColor =  UIColor(resource: .colorSet)
        nameLabel.font = Font.avenir(weight: .medium, size: 19)
        nameLabel.numberOfLines = .zero
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalToSuperview().offset(20)
            maker.right.left.equalTo(createdDateLabel)
        }
        
        descriptionLabel.textColor = UIColor(resource: .colorSet).withAlphaComponent(0.7)
        descriptionLabel.font = Font.avenir(weight: .medium, size: 17)
        descriptionLabel.numberOfLines = .zero
        descriptionLabel.textAlignment = .left
        descriptionLabel.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.left.right.equalTo(nameLabel)
        }
        
        completedSwitch.backgroundColor = UIColor(resource: .colorSet)
        completedSwitch.layer.cornerRadius = 15
        completedSwitch.onTintColor = UIColor(resource: .switch)
        completedSwitch.addTarget(self, action: #selector(didTapSwitch), for: .touchUpInside)
        completedSwitch.snp.makeConstraints { maker in
            maker.top.equalTo(descriptionLabel.snp.bottom).offset(10)
            maker.centerX.equalTo(nameLabel)
        }
    }
    
    func configure(item: ToDoViewModel) {
        viewModel = item
        createdDateLabel.text = item.created
        nameLabel.text = item.name
        descriptionLabel.text = item.description
        completedSwitch.isOn = item.completed
        let color = UIColor(resource: .colorView)
        containerView.backgroundColor = item.completed ? color.withAlphaComponent(0.5) : color
    }
    
    @objc private func didTapSwitch() {
        viewModel?.onToggle()
    }
}
