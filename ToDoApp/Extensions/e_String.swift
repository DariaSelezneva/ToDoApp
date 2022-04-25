//
//  e_String.swift
//  ToDoApp
//
//  Created by Daria on 22.04.2022.
//

import Foundation

extension String {
    
    func withoutExtraSpaces() -> String {
        var string = self
        while string.contains("  ") {
            string = string.replacingOccurrences(of: "  ", with: " ")
        }
        while string.last == " " {
            string.removeLast()
        }
        return string
    }
}
