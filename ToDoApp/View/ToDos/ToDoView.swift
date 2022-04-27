//
//  ToDoView.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

struct ToDoView: View {
    
    @ObservedObject var viewModel : ToDoViewModel = ToDoViewModel()
    
    @State private var isEditing: Bool = false
    @State private var editingTodoID: Int?
    
    @State private var todoIDtoDelete : Int?
    
    @State private var isShowingSingleDeletionWarning : Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                ToDoViewHeader(viewModel: viewModel, isEditing: $isEditing, onTapAdd: {
                    let todo = Todo(id: -1, text: "", isReady: false)
                    isEditing = true
                    editingTodoID = -1
                    viewModel.todos.append(todo)
                })
                HStack {
                    Text("Active: \(viewModel.active), completed: \(viewModel.completed)")
                    Spacer()
                }
                .alert(item: $viewModel.error) { error in
                    Alert(title: Text(error))
                }
                .padding(.horizontal, 20)
                ScrollViewReader { proxy in
                    List {
                        ForEach(Array(zip(viewModel.todos.indices, viewModel.todos)), id: \.0) { index, todo in
                            ToDoCell(todo: todo, isEditing: todo.id == editingTodoID, onTapChecked: {
                                viewModel.toggleToDo(todoID: todo.id)
                            }, onTapSave: { text in
                                viewModel.saveToDo(todoID: todo.id, text: text)
                                isEditing = false
                                editingTodoID = nil
                            }, onTapCancel: {
                                if editingTodoID == -1 {
                                    viewModel.todos.removeLast()
                                }
                                isEditing = false
                                editingTodoID = nil
                            })
                            .onAppear {
                                if index == viewModel.todos.count - 1 && !isEditing {
                                    viewModel.loadMore()
                                }
                            }
                            .swipeActions {
                                if editingTodoID == nil {
                                    Button(role: .destructive) {
                                        todoIDtoDelete = todo.id
                                        isShowingSingleDeletionWarning = true
                                    } label: {
                                        Image(systemName: "trash")
                                    }
                                    Button {
                                        isEditing = true
                                        editingTodoID = todo.id
                                    } label : {
                                        Image(systemName: "pencil")
                                    }
                                }
                            }
                            .onChange(of: editingTodoID) { value in
                                if value == -1 {
                                    proxy.scrollTo(viewModel.todos.count - 1)
                                }
                            }
                        }
                    }
                }
                .alert(isPresented: $isShowingSingleDeletionWarning) {
                    Alert.taskDeletion(title: "Do you want to delete this ToDo?") {
                        guard let id = todoIDtoDelete else { return }
                        viewModel.deleteToDo(todoID: id)
                    }
                }
            }
            if viewModel.loadingState == .loading {
                ProgressView()
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView()
    }
}
