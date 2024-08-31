//
//  ToDoViewModel.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

struct ToDoViewModel {
    var id: Int
    var name: String?
    var description: String
    var created: String?
    var completed: Bool
    
    let onToggle: () -> Void
}

extension ToDoViewModel: Hashable {
    static func == (lhs: ToDoViewModel, rhs: ToDoViewModel) -> Bool {
        lhs.id == rhs.id &&
        lhs.completed == rhs.completed &&
        lhs.name == rhs.name &&
        lhs.description == rhs.description &&
        lhs.created == rhs.created
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(description)
        hasher.combine(created)
        hasher.combine(completed)
    }
}
