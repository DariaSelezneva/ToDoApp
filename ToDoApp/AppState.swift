//
//  AppState.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import Foundation

class AppState : ObservableObject {
    
    @Published var todos : [Todo] = Todo.sample
    @Published var active : Int = 0
    @Published var completed : Int = 0
    
    var isMore : Bool { active + completed > todos.count }
}
