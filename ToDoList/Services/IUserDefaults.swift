//
//  IUserDefaults.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

protocol IUserDefaults {
    func set(value: Any?, forKey: String)
    func bool(forKey: String) -> Bool
}

extension UserDefaults: IUserDefaults {
    func set(value: Any?, forKey: String) {
        setValue(value, forKey: forKey)
    }
}
