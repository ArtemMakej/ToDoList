//
//  DateFormatter+Ext.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

extension DateFormatter {
    static let shortRuFormmater: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = .none
        dateFormatter.dateStyle = .short
        return dateFormatter
    }()
}
