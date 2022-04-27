//
//  ToDoGetData.swift
//  ToDoApp
//
//  Created by Daria on 27.04.2022.
//

import Foundation

struct ToDoGetResponse {
    var todos: [Todo]
    var active: Int
    var completed: Int
}

extension ToDoGetResponse: Decodable {
    
    enum RootKeys: String, CodingKey {
        case data, statusCode, success
    }
    
    enum ContentCodingKeys: String, CodingKey {
        case content, notReady, numberOfElements, ready
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let data = try container.nestedContainer(keyedBy: ContentCodingKeys.self, forKey: .data)
        active = try data.decode(Int.self, forKey: .notReady)
        completed = try data.decode(Int.self, forKey: .ready)
        let content = try data.decode(Array<Todo>.self, forKey: .content)
        todos = content
    }
}
