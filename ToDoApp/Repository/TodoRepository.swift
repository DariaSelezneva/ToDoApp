//
//  TodoRepository.swift
//  ToDoApp
//
//  Created by Daria on 22.04.2022.
//

import Foundation
import Combine

class TodoRepository {
    
    private func startURLSession(request: URLRequest, onSuccess: @escaping () -> (), onError: @escaping (Error) -> ()) {
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data,
                   let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
                   let success = jsonDict["success"] as? Bool,
                   success == true {
                    onSuccess()
                }
                else if let error = error {
                    onError(error)
                }
            }
        }
        session.resume()
    }
    
    func getTodos(page: Int, perPage: Int, status: Bool?, completion: @escaping (_ todos: [Todo]?, _ active: Int?, _ completed: Int?, _ error: Error?) -> Void) {
        let request = API.getTodosRequest(page: page, perPage: perPage, status: status)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let data = jsonDict["data"] as? [String : Any],
               let content = data["content"] as? [[String : Any]],
               let ready = data["ready"] as? Int,
               let notReady = data["notReady"] as? Int {
                let todos = content.compactMap({Todo.init(from: $0)}).sorted(by: <)
                completion(todos, notReady, ready, nil)
            }
            else if let error = error {
                completion(nil, nil, nil, error)
            }
        }
        session.resume()
    }
    
    func toggleToDo(todoID: Int, setReady: Bool, onSuccess: @escaping () -> (), onError: @escaping (Error) -> ()) {
        guard let request = API.toggleToDoRequest(todoID: todoID, setReady: setReady) else { return }
        startURLSession(request: request, onSuccess: onSuccess, onError: onError)
    }
    
    
    func createToDo(text: String, onSuccess: @escaping (Todo) -> (), onError: @escaping (Error) -> ()) {
        guard let request = API.createToDoRequest(text: text) else { return }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let todoData = jsonDict["data"] as? [String : Any],
               let todo = Todo(from: todoData) {
                onSuccess(todo)
            }
            else if let error = error {
                onError(error)
            }
        }
        session.resume()
    }
    
    func saveToDo(todoID: Int, text: String, onSuccess: @escaping () -> (), onError: @escaping (Error) -> ()) {
        guard let request = API.saveToDoRequest(todoID: todoID, text: text) else { return }
        startURLSession(request: request, onSuccess: onSuccess, onError: onError)
    }
    
    func deleteToDo(todoID: Int, onSuccess: @escaping () -> (), onError: @escaping (Error) -> ()) {
        let request = API.deleteToDoRequest(todoID: todoID)
        startURLSession(request: request, onSuccess: onSuccess, onError: onError)
    }
    
    func setStatusToAll(setReady: Bool, onSuccess: @escaping () -> (), onError: @escaping (Error) -> ()) {
        guard let request = API.setStatusToAllRequest(setReady: setReady) else { return }
        startURLSession(request: request, onSuccess: onSuccess, onError: onError)
    }
    
    func deleteAllReady(onSuccess: @escaping () -> (), onError: @escaping (Error) -> ()) {
        let request = API.deleteAllReadyRequest()
        startURLSession(request: request, onSuccess: onSuccess, onError: onError)
    }
}
