//
//  INetworkService.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

protocol INetworkService {
    func dataTask(
        with request: URLRequest,
        completionHandler: @escaping @Sendable (Data?, URLResponse?, Error?) -> Void
    ) -> URLSessionDataTask
}

extension URLSession: INetworkService {
    
}
