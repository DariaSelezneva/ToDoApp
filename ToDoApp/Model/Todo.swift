//
//  Todo.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import Foundation

struct Todo : Identifiable {
    
    var id: Int
    var text: String
    var isReady: Bool
    
    static let sample = [Todo(id: 0, text: "Some todo", isReady: false), Todo(id: 1, text: "Another todo", isReady: true)]
}

extension Todo {
    init?(from dict: [String : Any]) {
        guard let id = dict["id"] as? Int,
              let title = dict["text"] as? String,
              let isReady = dict["status"] as? Bool else { return nil }
        self.id = id
        self.text = title
        self.isReady = isReady
    }
}

extension Todo : Comparable {
    static func < (lhs: Todo, rhs: Todo) -> Bool {
        return lhs.id < rhs.id
    }
}

extension Todo : Codable {
    
}
