//
//  e_Alert.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//


import SwiftUI

extension Alert {
    
    static func taskDeletion(title: String, handler: @escaping () -> Void) -> Alert {
        return Alert(
            title: Text(title),
            message: Text(""),
            primaryButton: .default(Text("Cancel"), action: {}),
            secondaryButton: .destructive(Text("Delete"), action: handler))
    }
}
