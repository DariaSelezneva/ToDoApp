//
//  ToDoCreateResponse.swift
//  ToDoApp
//
//  Created by Daria on 27.04.2022.
//

import Foundation

struct ToDoCreateResponse {
    var todo: Todo
}

extension ToDoCreateResponse: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case data, statusCode, success
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        todo = try container.decode(Todo.self, forKey: .data)
    }
}
