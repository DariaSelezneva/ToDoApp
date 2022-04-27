//
//  ToDoViewHeader.swift
//  ToDoApp
//
//  Created by Daria on 25.04.2022.
//

import SwiftUI

struct ToDoViewHeader: View {
    
    let viewModel: ToDoViewModel
    
    @State private var isShowingAllReadyDeletionWarning : Bool = false
    
    let onTapAdd: () -> ()
    
    var body: some View {
        HStack {
            Menu {
                Button {
                    viewModel.showsActive.toggle()
                } label: {
                    Label("Active", systemImage: viewModel.showsActive ? "checkmark" : "")
                }
                Button {
                    viewModel.showsCompleted.toggle()
                } label: {
                    Label("Completed", systemImage: viewModel.showsCompleted ? "checkmark" : "")
                }
            } label: {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .font(.system(size: 32))
            }
            .frame(width: 50, height: 50)
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
        .padding()
    }
}

struct ToDoViewHeader_Previews: PreviewProvider {
    static var previews: some View {
        ToDoViewHeader(viewModel: ToDoViewModel(), onTapAdd: {})
    }
}
