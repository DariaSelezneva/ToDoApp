//
//  ToDoView.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

struct ToDoView: View {
    
    @StateObject var viewModel: ToDoViewModelAsync
    
    init() {
        self._viewModel = StateObject(wrappedValue: ToDoViewModelAsync())
    }
    
    @State private var isEditing: Bool = false
    @State private var editingTodoID: Int?
    @State var changedText: String = ""
    
    var body: some View {
        ZStack {
            VStack {
                ToDoViewHeader(viewModel: viewModel, isEditing: $isEditing, onTapAdd: {
                    addTodo()
                })
                HStack {
                    Text("Active: \(viewModel.active), completed: \(viewModel.completed)")
                    Spacer()
                    Button {
                        viewModel.refresh()
                    } label: {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .font(.system(size: 24))
                            .frame(width: 40, height: 40)
                    }
                    .disabled(isEditing)
                }
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text(error))
                }
                .padding(.horizontal, 20)
                ToDoList(viewModel: viewModel, isEditing: $isEditing, editingTodoID: $editingTodoID, changedText: $changedText)
            }
            if viewModel.loadingState == .loading {
                ProgressView()
            }
        }
    }
    
    private func addTodo() {
        let todo = Todo(id: -1, text: "", isReady: false)
        isEditing = true
        editingTodoID = -1
        changedText = ""
        viewModel.todos.append(todo)
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
