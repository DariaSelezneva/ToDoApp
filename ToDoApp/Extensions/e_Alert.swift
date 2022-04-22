//
//  e_Alert.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//


import SwiftUI

extension Alert {
    
    static func taskDeletion(_ handler: @escaping () -> Void) -> Alert {
        return Alert(
            title: Text("Do you want to delete this ToDo?"),
            message: Text(""),
            primaryButton: .destructive(Text("Delete"), action: handler),
            secondaryButton: .default(Text("Cancel"), action: {}))
    }
}
