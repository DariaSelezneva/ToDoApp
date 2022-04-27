//
//  TodoRepository.swift
//  ToDoApp
//
//  Created by Daria on 22.04.2022.
//

import Foundation
import Combine

protocol ToDoRepositoryLogic {
    
}

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
    
    func getTodos(page: Int, perPage: Int, status: Bool?, onSuccess: @escaping (ToDoGetResponse) -> (), onError: @escaping (Error) -> ()) {
        let request = API.getTodosRequest(page: page, perPage: perPage, status: status)
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let response =  try decoder.decode(ToDoGetResponse.self, from: data)
                        onSuccess(response)
                    } catch {
                        onError(error)
                    }
                }
                else if let error = error {
                    onError(error)
                }
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
            DispatchQueue.main.async {
                if let data = data {
                    let decoder = JSONDecoder()
                    do {
                        let createResponse = try decoder.decode(ToDoCreateResponse.self, from: data)
                        onSuccess(createResponse.todo)
                    } catch {
                        onError(error)
                    }
                }
                else if let error = error {
                    onError(error)
                }
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
