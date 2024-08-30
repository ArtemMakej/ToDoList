//
//  Model.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import Foundation

struct ToDoModel: Hashable {
    var id: Int
    var name: String
    var completed: Bool
    var userId: Int
}
