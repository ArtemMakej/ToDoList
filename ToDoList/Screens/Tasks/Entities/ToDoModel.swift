//
//  Model.swift
//  ToDoList
//
//  Created by Artem Mackei on 28.08.2024.
//

import UIKit

struct ToDoModel: Hashable, Decodable {
    // Имя
    var todo: String
    // Описание
    var description: String?
    // Дата создания
    var dateOfCreation: String?
    // Готово
    var completed: Bool
    
    var id: Int
}

extension ToDoModel {
    
    init(from entity: ToDoEntity) {
        self.init(
            todo: entity.todoName,
            description: entity.todoDescription,
            dateOfCreation: entity.dateOfCreation,
            completed: entity.isCompleted,
            id: Int(entity.id)
        )
    }
}
