//
//  TodoInteractor.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

class TodoInteractor {
    
    let repository: TodoRepository = TodoRepository()
    
    enum Filter {
        case all
        case active
        case completed
        case nothing
    }
    
    var appState: AppState
    
    var showsActive : Bool = true {
        didSet {
            refresh()
        }
    }
    var showsCompleted : Bool = true {
        didSet {
            refresh()
        }
    }
    
    var selectedFilter: Filter {
        if showsCompleted && showsActive {
            return .all
        }
        else if showsActive {
            return .active
        }
        else if showsCompleted {
            return .completed
        }
        else {
            return .nothing
        }
    }
    
    var page : Int = 1
    var perPage : Int = 10
    
    init(appState: AppState) {
        self.appState = appState
        getTodos()
    }
    
    func getTodos(page: Int = 1, perPage: Int = 10) {
        guard selectedFilter != .nothing else {
            appState.todos = []
            return
        }
        var status: Bool?
        switch selectedFilter {
        case .all: status = nil
        case .active: status = false
        case .completed: status = true
        case .nothing: break
        }
        repository.getTodos(page: page, perPage: perPage, status: status) { todos, active, completed, error in
            DispatchQueue.main.async {
                if let todos = todos, let active = active, let completed = completed {
                    self.appState.todos = todos
                    self.appState.active = active
                    self.appState.completed = completed
                }
                else if let error = error {
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func loadMore() {
        if appState.isMore {
            print("gets called")
            page += 1
            guard selectedFilter != .nothing else {
                appState.todos = []
                return
            }
            var status: Bool?
            switch selectedFilter {
            case .all: status = nil
            case .active: status = false
            case .completed: status = true
            case .nothing: break
            }
            repository.getTodos(page: page, perPage: perPage, status: status) { todos, _, _, error in
                DispatchQueue.main.async {
                    if let todos = todos {
                        self.appState.todos.append(contentsOf: todos)
                    }
                    else if let error = error {
                        print(error.localizedDescription)
                    }
                }
            }
        }
    }
    
    func refresh() {
        page = 1
        getTodos()
    }
    
    func saveToDo(todoID: Int, text: String) {
        print("saving todo \(text)")
    }
    
    func toggleToDo(todoID: Int) {
        guard let todo = appState.todos.first(where: {$0.id == todoID}) else { return }
        let isReady = todo.isReady
        var request = URLRequest(url: AppURL.patchTodoStatusURL(id: todoID))
        request.httpMethod = "PATCH"
        let jsonDict = ["status" : isReady]
        guard let jsonData = try? JSONSerialization.data(withJSONObject: jsonDict, options: []) else { return }
        request.httpBody = jsonData
        let session = URLSession.shared.dataTask(with: request) { data, response, error in
            if let data = data, let jsonDict = try? JSONSerialization.jsonObject(with: data, options: []) as? [String : Any] {
                print(jsonDict)
            }
        }
        session.resume()
    }
    
    func setAllActive() {
        
    }
    
    func setAllCompleted() {
        
    }
    
    func deleteToDo(todoID: Int) {
        print("deletingToDo with id \(todoID)")
    }
    
    func deleteAllCompleted() {
        
    }
}
