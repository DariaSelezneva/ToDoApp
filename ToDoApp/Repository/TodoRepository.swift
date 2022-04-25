//
//  TodoRepository.swift
//  ToDoApp
//
//  Created by Daria on 22.04.2022.
//

import Foundation
import Combine

class TodoRepository {
    
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
    
    func toggleToDo(todoID: Int, setReady: Bool, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let request = API.toggleToDoRequest(todoID: todoID, setReady: setReady) else { return }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let success = jsonDict["success"] as? Bool {
                completion(success, nil)
            }
            else if let error = error {
                print(error)
                completion(false, error)
            }
        }
        session.resume()
    }
    
//    func toggleToDoPublisher(todoID: Int, setReady: Bool) -> AnyPublisher<Bool, Error>? {
//        guard let request = API.toggleToDoRequest(todoID: todoID, setReady: setReady) else { return nil }
//        return URLSession.shared.dataTaskPublisher(for: request)
//            .receive(on: DispatchQueue.main)
//            .mapError { $0 as Error }
//            .compactMap { try? JSONSerialization.jsonObject(with: $0.data, options: []) as? [String : Any] }
//            .print()
//            .compactMap { $0["success"] as? Bool }
//            .eraseToAnyPublisher()
//    }
    
    func createToDo(text: String, completion: @escaping (_ todo: Todo?, _ error: Error?) -> Void) {
        guard let request = API.createToDoRequest(text: text) else { return }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let todoData = jsonDict["data"] as? [String : Any],
            let todo = Todo(from: todoData) {
                completion(todo, nil)
            }
            else if let error = error {
                completion(nil, error)
            }
        }
        session.resume()
    }
    
    func saveToDo(todoID: Int, text: String, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        guard let request = API.saveToDoRequest(todoID: todoID, text: text) else { return }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let success = jsonDict["success"] as? Bool {
                completion(success, nil)
            }
            else if let error = error {
                completion(false, error)
            }
        }
        session.resume()
    }
    
    func deleteToDo(todoID: Int, completion: @escaping (_ success: Bool, _ error: Error?) -> Void) {
        let request = API.deleteToDoRequest(todoID: todoID)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let success = jsonDict["success"] as? Bool {
                completion(success, nil)
            }
            else if let error = error {
                completion(false, error)
            }
        }
        session.resume()
    }
    
    func setStatusToAll(setReady: Bool, completion: @escaping (Bool, Error?) -> Void) {
        guard let request = API.setStatusToAllRequest(setReady: setReady) else { return }
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let success = jsonDict["success"] as? Bool {
                completion(success, nil)
            }
            else if let error = error {
                completion(false, error)
            }
        }
        session.resume()
    }
    
    func deleteAllReady(completion: @escaping (Bool, Error?) -> Void) {
        let request = API.deleteAllReadyRequest()
        let session = URLSession.shared.dataTask(with: request) {data, response, error in
            if let data = data,
               let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any],
               let success = jsonDict["success"] as? Bool {
                completion(success, nil)
            }
            else if let error = error {
                completion(false, error)
            }
        }
        session.resume()
    }
}
