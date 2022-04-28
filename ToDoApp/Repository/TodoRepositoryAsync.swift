//
//  TodoRepositoryAsync.swift
//  ToDoApp
//
//  Created by Daria on 28.04.2022.
//

enum NetworkError: Error {
    case badURL
    case incorrectRequest
    case serverError
    case unknown
}

import Foundation

class TodoRepositoryAsync {
    
    lazy var decoder = JSONDecoder()
    
    func getTodos(page: Int, perPage: Int, status: Bool?) async throws -> ToDoGetResponse {
        let request = API.getTodosRequest(page: page, perPage: perPage, status: status)
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(ToDoGetResponse.self, from: data)
    }
    
    func toggleTodo(todoID: Int, setReady: Bool) async throws {
        guard let request = API.toggleToDoRequest(todoID: todoID, setReady: setReady) else { throw NetworkError.badURL }
        try await result(of: request)
    }
    
    func createToDo(text: String) async throws -> Todo {
        guard let request = API.createToDoRequest(text: text) else { throw NetworkError.badURL }
        let (data, _) = try await URLSession.shared.data(for: request)
        return try decoder.decode(ToDoCreateResponse.self, from: data).todo
    }
    
    func saveToDo(todoID: Int, text: String) async throws {
        guard let request = API.saveToDoRequest(todoID: todoID, text: text) else { throw NetworkError.badURL }
        return try await result(of: request)
    }
    
    func deleteToDo(todoID: Int) async throws {
        let request = API.deleteToDoRequest(todoID: todoID)
        try await result(of: request)
    }
    
    func setStatusToAll(setReady: Bool) async throws {
        guard let request = API.setStatusToAllRequest(setReady: setReady) else { throw NetworkError.badURL }
        try await result(of: request)
    }
    
    func deleteAllReady() async throws {
        let request = API.deleteAllReadyRequest()
        try await result(of: request)
    }
    
    private func result(of request: URLRequest) async throws {
        let (data, _) = try await URLSession.shared.data(for: request)
        let response = try decoder.decode(ToDoSuccessResponse.self, from: data)
        if !response.success { throw NetworkError.incorrectRequest }
    }
}
