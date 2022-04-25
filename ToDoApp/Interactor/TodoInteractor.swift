//
//  TodoInteractor.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI
import Combine

class TodoInteractor {
    
    let repository: TodoRepository = TodoRepository()
    
    var cancellables: [AnyCancellable] = []
    
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
                    self.appState.error = error.localizedDescription
                }
            }
        }
    }
    
    func loadMore() {
        if appState.isMore {
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
            repository.getTodos(page: page, perPage: perPage, status: status) { [unowned self] todos, _, _, error in
                DispatchQueue.main.async {
                    if let todos = todos {
                        self.appState.todos.append(contentsOf: todos)
                    }
                    else if let error = error {
                        self.appState.error = error.localizedDescription
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
        if todoID == -1 {
            repository.createToDo(text: text) { [unowned self] todo, error in
                DispatchQueue.main.async {
                    if let todo = todo, error == nil {
                        self.appState.add(todo: todo)
                    }
                    else if let error = error {
                        self.appState.error = error.localizedDescription
                    }
                }
            }
        }
        else {
            repository.saveToDo(todoID: todoID, text: text) { [unowned self] success, error in
                DispatchQueue.main.async {
                    if success, error == nil {
                        self.appState.updateToDo(with: todoID, text: text)
                    }
                    else if let error = error {
                        self.appState.error = error.localizedDescription
                    }
                }
            }
        }
    }
    
    func toggleToDo(todoID: Int) {
        guard let todo = appState.todos.first(where: {$0.id == todoID}) else { return }
        let setReady = !todo.isReady
        repository.toggleToDo(todoID: todoID, setReady: setReady) { [unowned self] success, error in
            DispatchQueue.main.async {
                if success, error == nil {
                    self.appState.toggleToDo(id: todoID, setReady: setReady)
                }
                else if let error = error {
                    self.appState.error = error.localizedDescription
                }
            }
        }
    }
    
    func setStatusToAll(setReady: Bool) {
        repository.setStatusToAll(setReady: setReady) { [unowned self] success, error in
            DispatchQueue.main.async {
                if success, error == nil {
                    self.appState.setStatusToAll(setReady: setReady)
                }
                else if let error = error {
                    self.appState.error = error.localizedDescription
                }
            }
        }
    }
    
    func deleteToDo(todoID: Int) {
        repository.deleteToDo(todoID: todoID) { [unowned self] success, error in
            DispatchQueue.main.async {
                if success, error == nil {
                    self.appState.deleteToDo(with: todoID)
                }
                else if let error = error {
                    self.appState.error = error.localizedDescription
                }
            }
        }
    }
    
    func deleteAllReady() {
        repository.deleteAllReady { [unowned self] success, error in
            DispatchQueue.main.async {
                if success, error == nil {
                    self.appState.deleteAllReady()
                }
                else if let error = error {
                    self.appState.error = error.localizedDescription
                }
            }
        }
    }
}
