//
//  ToDoAppApp.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

@main
struct ToDoAppApp: App {
    
    let appState: AppState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ToDoView(interactor: TodoInteractor(appState: appState))
                .environmentObject(appState)
        }
    }
}
