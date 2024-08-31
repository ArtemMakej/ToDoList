//
//  RemoteTodosService.swift
//  ToDoList
//
//  Created by Artem Mackei on 29.08.2024.
//

import Foundation

protocol IRemoteTodosService {
    func loadTodos(completion: @escaping (Result<[ToDoModel], Error>) -> Void)
}

final class RemoteTodosService: IRemoteTodosService {
    
    enum ServiceError: Error {
        case failedToCreateUrl
    }
    
    private let network: INetworkService
    private let jsonDecoder = JSONDecoder()
    
    init(network: INetworkService) {
        self.network = network
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
    }
    
    func loadTodos(completion: @escaping (Result<[ToDoModel], Error>) -> Void) {
        guard let url = URL(string: "https://dummyjson.com/todos") else {
            completion(.failure(ServiceError.failedToCreateUrl))
            return
        }
        
        let request = URLRequest(url: url)
        network.dataTask(with: request) { [weak self] data, response, error in
            if let error {
                completion(.failure(error))
            }

            guard let self, let data else { return }
            do {
                let result = try self.jsonDecoder.decode(ToDosWrapper.self, from: data)
                completion(.success(result.todos))
            } catch {
                completion(.failure(error))
            }
        }
        .resume()
    }
}
