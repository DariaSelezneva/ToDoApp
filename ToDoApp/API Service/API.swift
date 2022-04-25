//
//  API.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import Foundation

struct API {
    
    static private let baseURL = "https://news-feed.dunice-testing.com/api/v1"
    
    static private func getTodos(page: Int = 1, perPage: Int = 10, status: Bool?) -> String {
        let status = status == nil ? "" : "&status=\(status!)"
        return "?page=\(page)&perPage=\(perPage)" + status }
    
    static private let todo = "/todo"
    
    // MARK: - URLs
    static private func getTodosURL(page: Int = 1, perPage: Int = 10, status: Bool?) -> URL {
        URL(string: baseURL + todo + getTodos(page: page, perPage: perPage, status: status))!
    }
    
    static private let todoURL = URL(string: baseURL + todo)!
    
    static private func deleteTodo(id: Int) -> URL { URL(string: baseURL + todo + "/\(id)")! }
    
    static private func patchTodoStatusURL(id: Int) -> URL { URL(string: baseURL + todo + "/status/\(id)")! }
    
    static private func patchTodoTextURL(id: Int) -> URL {
        URL(string: baseURL + todo + "/text/\(id)")!
    }
    
    // MARK: - URLRequests
    
    static func getTodosRequest(page: Int, perPage: Int, status: Bool?) -> URLRequest {
        var request = URLRequest(url: API.getTodosURL(page: page, perPage: perPage, status: status))
        request.httpMethod = "GET"
        return request
    }
    
    static func toggleToDoRequest(todoID: Int, setReady: Bool) -> URLRequest? {
        var request = URLRequest(url: API.patchTodoStatusURL(id: todoID))
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["status" : setReady]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return nil }
        request.httpBody = jsonData
        return request
    }
    
    static func createToDoRequest(text: String) -> URLRequest? {
        var request = URLRequest(url: API.todoURL)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["text" : text]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return nil }
        request.httpBody = jsonData
        return request
    }
    
    static func saveToDoRequest(todoID: Int, text: String) -> URLRequest? {
        var request = URLRequest(url: API.patchTodoTextURL(id: todoID))
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["text" : text]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return nil }
        request.httpBody = jsonData
        return request
    }
    
    static func deleteToDoRequest(todoID: Int) -> URLRequest {
        var request = URLRequest(url: API.deleteTodo(id: todoID))
        request.httpMethod = "DELETE"
        return request
    }
    
    static func setStatusToAllRequest(setReady: Bool) -> URLRequest? {
        var request = URLRequest(url: API.todoURL)
        request.httpMethod = "PATCH"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["status" : setReady]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else { return nil }
        request.httpBody = jsonData
        return request
    }
    
    static func deleteAllReadyRequest() -> URLRequest {
        var request = URLRequest(url: API.todoURL)
        request.httpMethod = "DELETE"
        return request
    }
}
