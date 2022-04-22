//
//  TodoRepository.swift
//  ToDoApp
//
//  Created by Daria on 22.04.2022.
//

import Foundation

class TodoRepository {
    
    func getTodos(page: Int, perPage: Int, status: Bool?, completion: @escaping (_ todos: [Todo]?, _ active: Int?, _ completed: Int?, _ error: Error?) -> Void) {
        var request = URLRequest(url: AppURL.getTodosURL(page: page, perPage: perPage, status: status))
        request.httpMethod = "GET"
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
    
    
}
