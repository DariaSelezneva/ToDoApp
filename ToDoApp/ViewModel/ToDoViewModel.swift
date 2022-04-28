//
//  ToDoViewModel.swift
//  ToDoApp
//
//  Created by Daria on 27.04.2022.
//


import Foundation


class ToDoViewModel: ObservableObject {
    
    let repository: TodoRepository = TodoRepository()
    
    // MARK: - Loading state
    
    enum LoadingState {
        case idle
        case loading
        case success
        case error
    }
    
    @Published var loadingState : LoadingState = .idle
    
    // MARK: - Data
    
    @Published var todos : [Todo] = []
    @Published var active : Int = 0
    @Published var completed : Int = 0
    
    @Published var error: String? = nil
    
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
        guard selectedFilter != .nothing else {
            todos = []
            return
        }
        loadingState = .loading
        repository.getTodos(page: page, perPage: perPage, status: status, onSuccess: { [unowned self] getResponse in
            loadingState = .success
            todos = getResponse.todos
            active = getResponse.active
            completed = getResponse.completed
        }, onError: onError(_:))
    }
    
    func loadMore() {
        if isMore {
            loadingState = .loading
            page += 1
            guard selectedFilter != .nothing else { todos = []; return }
            repository.getTodos(page: page, perPage: perPage, status: status, onSuccess: { [unowned self] getResponse in
                loadingState = .success
                todos.append(contentsOf: getResponse.todos)
            }, onError: onError(_:))
        }
    }
    
    func refresh() {
        page = 1
        getTodos()
    }
    
    func saveToDo(todoID: Int, text: String) {
        loadingState = .loading
        if todoID == -1 {
            repository.createToDo(text: text, onSuccess: { [unowned self] todo in
                loadingState = .success
                loadingState = .success
                let count = todos.count
                todos[count - 1] = todo
                active += 1
            }, onError: onError(_:))
        }
        else {
            repository.saveToDo(todoID: todoID, text: text, onSuccess: { [unowned self] in
                loadingState = .success
                guard let index = self.todos.firstIndex(where: {$0.id == todoID}) else { return }
                todos[index].text = text
            }, onError: onError(_:))
        }
    }
    
    func toggleToDo(todoID: Int) {
        guard let todo = todos.first(where: {$0.id == todoID}) else { return }
        loadingState = .loading
        let setReady = !todo.isReady
        repository.toggleToDo(todoID: todoID, setReady: setReady, onSuccess: { [unowned self] in
            loadingState = .success
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
        }, onError: onError(_:))
    }
    
    func setStatusToAll(setReady: Bool) {
        loadingState = .loading
        repository.setStatusToAll(setReady: setReady, onSuccess: { [unowned self] in
            loadingState = .success
            todos = todos.map({ todo in
                var todoToChange = todo
                todoToChange.isReady = setReady
                return todoToChange
            })
            let sum = active + completed
            active = setReady ? 0 : sum
            completed = setReady ? sum : 0
        }, onError: onError(_:))
    }
    
    func deleteToDo(todoID: Int) {
        loadingState = .loading
        repository.deleteToDo(todoID: todoID, onSuccess: { [unowned self] in
            loadingState = .success
            guard let index = todos.firstIndex(where: {$0.id == todoID}) else { return }
            let deletedTodo = todos.remove(at: index)
            if deletedTodo.isReady {
                completed -= 1
            }
            else {
                active -= 1
            }
        }, onError: onError(_:))
    }
    
    func deleteAllReady() {
        loadingState = .loading
        repository.deleteAllReady(onSuccess: { [unowned self] in
            loadingState = .success
            todos = todos.filter({ !$0.isReady })
            completed = 0
            page = 1
            getTodos()
        }, onError: onError(_:))
    }
    
    
    private func onError(_ error: Error?) {
        loadingState = .error
        self.error = error?.localizedDescription ?? "Unknown error"
    }
}
