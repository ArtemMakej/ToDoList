//
//  ToDoViewModel.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

struct ToDoViewModel: Hashable, Decodable {
    var id: Int
    var name: String?
    var description: String
    var created: String?
    var completed: Bool
}
