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
    
    private let idLabel = UILabel()
    private let nameLabel = UILabel()
    private let completedSwitch = UISwitch()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = frame.height / 2.5
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        contentView.backgroundColor = UIColor(resource: .colorView)
        contentView.clipsToBounds = true
        contentView.addSubview(nameLabel)
        contentView.addSubview(completedSwitch)
        contentView.snp.makeConstraints { maker in
            maker.left.right.equalToSuperview()
            maker.bottom.top.equalToSuperview()
        }
        
        nameLabel.textColor =  UIColor(resource: .colorSet)
        nameLabel.font = Font.avenir(weight: .medium, size: 19)
        nameLabel.numberOfLines = .zero
        nameLabel.textAlignment = .center
        nameLabel.snp.makeConstraints { maker in
            maker.top.equalTo(contentView.snp.top).offset(20)
            maker.right.left.equalToSuperview().inset(16)
        }
        
        completedSwitch.backgroundColor = UIColor(resource: .colorSet)
        completedSwitch.layer.cornerRadius = 15
        completedSwitch.onTintColor = UIColor(resource: .switch)
        completedSwitch.snp.makeConstraints { maker in
            maker.top.equalTo(nameLabel.snp.bottom).offset(10)
            maker.centerX.equalTo(nameLabel)
            maker.bottom.equalToSuperview().inset(20)
        }
    }
    
    func configure(item: ToDoViewModel) {
        nameLabel.text = item.name
        completedSwitch.isOn = item.completed
        let color = UIColor(resource: .colorView)
        contentView.backgroundColor = item.completed ? color.withAlphaComponent(0.5) : color
    }
}
