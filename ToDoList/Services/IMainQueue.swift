//
//  IMainQueue.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

protocol IMainQueue {
    func runOnMain(work: @escaping () -> Void)
}

extension DispatchQueue: IMainQueue {
    func runOnMain(work: @escaping () -> Void) {
        Self.main.async(execute: work)
    }
}
