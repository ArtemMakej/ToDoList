//
//  Model.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

enum ToDoSection: Int {
    case main
}

enum ToDoCellType: Hashable {
    case main(ToDoModel)
}

struct ToDoModel: Hashable, Decodable {
    var id: Int
    var todo: String
    var completed: Bool
    var userId: Int
}

struct ToDosWrapper: Decodable {
    let todos: [ToDoModel]
}
