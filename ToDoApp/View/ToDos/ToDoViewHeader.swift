//
//  ToDoViewHeader.swift
//  ToDoApp
//
//  Created by Daria on 25.04.2022.
//

import SwiftUI

struct ToDoViewHeader: View {
    
    let viewModel: ToDoViewModelAsync
    
    @State private var isShowingAllReadyDeletionWarning : Bool = false
    
    @Binding var isEditing: Bool
    
    let onTapAdd: () -> ()
    
    var body: some View {
        HStack {
            Spacer()
            Menu {
                Button("Mark all as completed") {
                    viewModel.setStatusToAll(setReady: true)
                }
                Button("Mark all as active") {
                    viewModel.setStatusToAll(setReady: false)
                }
                Button("Delete all completed") {
                    isShowingAllReadyDeletionWarning = true
                }
            } label: {
                Image(systemName: "ellipsis")
                    .font(.system(size: 32))
                    .frame(width: 50, height: 50)
            }
            .alert(isPresented: $isShowingAllReadyDeletionWarning) {
                Alert.taskDeletion(title: "Do you want to delete all completed tasks?") {
                    viewModel.deleteAllReady()
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
        .disabled(isEditing)
        .padding()
    }
}

struct ToDoViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        ToDoViewHeader(viewModel: ToDoViewModelAsync(), isEditing: .constant(false), onTapAdd: {})
    }
}
