//
//  ToDoViewModelAsync.swift
//  ToDoApp
//
//  Created by Daria on 28.04.2022.
//

import Foundation

@MainActor
class ToDoViewModelAsync : ObservableObject {
    
    let repository = TodoRepositoryAsync()
    
    // MARK: - Loading state
    
    @Published var loadingState : LoadingState = .idle
    
    // MARK: - Data
    
    @Published var todos : [Todo] = [] {
        didSet {
            loadingState = .success
        }
    }
    @Published var active : Int = 0
    @Published var completed : Int = 0
    
    @Published var error: String? = nil {
        didSet {
            if error != nil {
                loadingState = .error
            }
        }
    }
    
    var isMore : Bool { active + completed > todos.count }
    
    enum Filter {
        case all
        case active
        case completed
        case nothing
    }
    
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
    var status: Bool? {
        switch selectedFilter {
        case .all: return nil
        case .active: return false
        case .completed: return true
        case .nothing: return nil
        }
    }
    
    // MARK: - Methods
    
    init() {
        getTodos()
    }
    
    func getTodos(page: Int = 1, perPage: Int = 10) {
        guard selectedFilter != .nothing else { todos = []; return }
        loadingState = .loading
        Task {
            do {
                let response = try await repository.getTodos(page: page, perPage: perPage, status: status)
                todos = response.todos.sorted(by: <)
                active = response.active
                completed = response.completed
            }
            catch { self.error = error.localizedDescription }
        }
    }
    
    func loadMore() {
        guard isMore else { return }
        loadingState = .loading
        page += 1
        guard selectedFilter != .nothing else { todos = []; return }
        Task {
            do {
                let response = try await repository.getTodos(page: page, perPage: perPage, status: status)
                var newTodos = todos
                newTodos.append(contentsOf: response.todos)
                todos = newTodos.sorted(by: <)
            }
            catch { self.error = error.localizedDescription }
        }
    }
    
    func refresh() {
        page = 1
        getTodos()
    }
    
    func saveToDo(todoID: Int, text: String) {
        loadingState = .loading
        if todoID == -1 {
            Task {
                do {
                    let todo = try await repository.createToDo(text: text)
                    let count = todos.count
                    todos[count - 1] = todo
                    active += 1
                    if selectedFilter == .completed {
                        refresh()
                    }
                }
                catch { self.error = error.localizedDescription }
            }
        }
        else {
            Task {
                do {
                    try await repository.saveToDo(todoID: todoID, text: text)
                    guard let index = self.todos.firstIndex(where: {$0.id == todoID}) else { return }
                    todos[index].text = text
                }
                catch { self.error = error.localizedDescription }
            }
        }
    }
    
    func toggleToDo(todoID: Int) {
        guard let todo = todos.first(where: {$0.id == todoID}) else { return }
        loadingState = .loading
        let setReady = !todo.isReady
        Task {
            do {
                try await repository.toggleTodo(todoID: todoID, setReady: setReady)
                guard let index = todos.firstIndex(where: {$0.id == todoID}) else { return }
                todos[index].isReady = setReady
                if setReady {
                    active -= 1
                    completed += 1
                }
                else {
                    active += 1
                    completed -= 1
                }
//                refresh()
            }
            catch { self.error = error.localizedDescription }
        }
    }
    
    func setStatusToAll(setReady: Bool) {
        loadingState = .loading
        Task {
            do {
                try await repository.setStatusToAll(setReady: setReady)
                todos = todos.map({ todo in
                    var todoToChange = todo
                    todoToChange.isReady = setReady
                    return todoToChange
                })
                let sum = active + completed
                active = setReady ? 0 : sum
                completed = setReady ? sum : 0
            }
            catch { self.error = error.localizedDescription }
        }
    }
    
    func deleteToDo(todoID: Int) {
        loadingState = .loading
        Task {
            do {
                try await repository.deleteToDo(todoID: todoID)
                guard let index = todos.firstIndex(where: {$0.id == todoID}) else { return }
                let deletedTodo = todos.remove(at: index)
                if deletedTodo.isReady {
                    completed -= 1
                }
                else {
                    active -= 1
                }
            }
            catch { self.error = error.localizedDescription }
        }
    }
    
    func deleteAllReady() {
        loadingState = .loading
        Task {
            do {
                try await repository.deleteAllReady()
                todos = todos.filter({ !$0.isReady })
                completed = 0
                page = 1
                getTodos()
            }
            catch { self.error = error.localizedDescription }
        }
    }
}
