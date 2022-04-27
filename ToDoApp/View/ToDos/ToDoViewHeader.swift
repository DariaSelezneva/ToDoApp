//
//  ToDoViewHeader.swift
//  ToDoApp
//
//  Created by Daria on 25.04.2022.
//

import SwiftUI

struct ToDoViewHeader: View {
    
    let interactor: TodoInteractor
    
    @State var isShowingAllReadyDeletionWarning : Bool = false
    
    let onTapAdd: () -> ()
    
    var body: some View {
        HStack {
            Menu {
                Button {
                    interactor.showsActive.toggle()
                } label: {
                    Label("Active", systemImage: interactor.showsActive ? "checkmark" : "")
                }
                Button {
                    interactor.showsCompleted.toggle()
                } label: {
                    Label("Completed", systemImage: interactor.showsCompleted ? "checkmark" : "")
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 32))
            }
            .frame(width: 50, height: 50)
            Spacer()
            Menu {
                Button("Mark all as completed") {
                    interactor.setStatusToAll(setReady: true)
                }
                Button("Mark all as active") {
                    interactor.setStatusToAll(setReady: false)
                }
                Button("Delete all completed") {
                    isShowingAllReadyDeletionWarning = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 32))
            }
            .alert(isPresented: $isShowingAllReadyDeletionWarning) {
                Alert.taskDeletion(title: "Do you want to delete all completed tasks?") {
                    interactor.deleteAllReady()
                }
            }
            .frame(width: 50, height: 50)
            Button {
                onTapAdd()
            } label: {
                Image(systemName: "plus")
                    .font(.system(size: 32))
            }
            .frame(width: 50, height: 50)
            
        }
        .padding()
    }
}

struct ToDoViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        ToDoViewHeader(interactor: TodoInteractor(appState: AppState()), onTapAdd: {})
    }
}
