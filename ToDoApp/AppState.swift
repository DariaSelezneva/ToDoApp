//
//  AppState.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import Foundation

class AppState : ObservableObject {
    
    @Published var todos : [Todo] = []
    @Published var active : Int = 0
    @Published var completed : Int = 0
    
    @Published var error: String? = nil
    
    var isMore : Bool { active + completed > todos.count }
    
    func toggleToDo(id: Int, setReady: Bool) {
        guard let index = todos.firstIndex(where: {$0.id == id}) else { return }
        todos[index].isReady = setReady
        adjustCountsOnToggle(setReady: setReady)
    }
    
    private func adjustCountsOnToggle(setReady: Bool) {
        if setReady {
            active -= 1
            completed += 1
        }
        else {
            active += 1
            completed -= 1
        }
    }
    
    func add(todo: Todo) {
        let count = todos.count
        todos[count - 1] = todo
        active += 1
    }
    
    func updateToDo(with id: Int, text: String) {
        guard let index = todos.firstIndex(where: {$0.id == id}) else { return }
        todos[index].text = text
    }
    
    
    
    func setStatusToAll(setReady: Bool) {
        todos = todos.map({ todo in
            var todoToChange = todo
            todoToChange.isReady = setReady
            return todoToChange
        })
        let sum = active + completed
        active = setReady ? 0 : sum
        completed = setReady ? sum : 0
    }
    
    func deleteToDo(with id: Int) {
        guard let index = todos.firstIndex(where: {$0.id == id}) else { return }
        let deletedTodo = todos.remove(at: index)
        if deletedTodo.isReady {
            completed -= 1
        }
        else {
            active -= 1
        }
    }
    
    func deleteAllReady() {
        todos = todos.filter({ !$0.isReady })
        completed = 0
    }
}
