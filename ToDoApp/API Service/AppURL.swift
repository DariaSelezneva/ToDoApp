//
//  AppURL.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import Foundation

struct AppURL {
    
    static private let baseURL = "https://news-feed.dunice-testing.com/api/v1/"
    
    static private func getTodos(page: Int = 1, perPage: Int = 10, status: Bool?) -> String {
        let status = status == nil ? "" : "&status=\(status!)"
        return "?page=\(page)&perPage=\(perPage)" + status }
    
    static private let todo = "todo"
    
    // MARK: - URLs
    static func getTodosURL(page: Int = 1, perPage: Int = 10, status: Bool?) -> URL {
        URL(string: baseURL + todo + getTodos(page: page, perPage: perPage, status: status))!
    }
    
    static let todoURL = URL(string: baseURL + todo)
    
    static func deleteTodo(id : Int) -> URL { URL(string: baseURL + todo + "/\(id)")! }
    
    static func patchTodoStatusURL(id: Int) -> URL { URL(string: baseURL + todo + "/status/\(id)")! }
    
    static func patchTodoTextURL(id: Int) -> URL {
        URL(string: baseURL + todo + "/text/\(id)")!
    }
}
