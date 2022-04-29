//
//  ToDoList.swift
//  ToDoApp
//
//  Created by Daria on 28.04.2022.
//

import SwiftUI

struct ToDoList: View {
    
    @ObservedObject var viewModel: ToDoViewModelAsync
    
    @Binding var isEditing: Bool
    @Binding var editingTodoID: Int?
    @Binding var changedText: String
    
    @State var todoIDtoDelete : Int?
    
    @State var isShowingSingleDeletionWarning : Bool = false
    
    var body: some View {
        ScrollViewReader { proxy in
            List {
                ForEach(Array(zip(viewModel.todos.indices, viewModel.todos)), id: \.0) { index, todo in
                    ToDoCell(todo: todo, isEditing: todo.id == editingTodoID, changedText: $changedText, onTapChecked: {
                        viewModel.toggleToDo(todoID: todo.id)
                    }, onTapSave: { text in
                        save(todoID: todo.id, text: text)
                    }, onTapCancel: {
                        cancelEditing()
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
                                changedText = todo.text
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
    
    private func save(todoID: Int, text: String) {
        viewModel.saveToDo(todoID: todoID, text: text)
        isEditing = false
        editingTodoID = nil
        changedText = ""
    }
    
    private func cancelEditing() {
        if editingTodoID == -1 {
            viewModel.todos.removeLast()
        }
        isEditing = false
        editingTodoID = nil
        changedText = ""
    }
}

struct ToDoList_Previews: PreviewProvider {
    static var previews: some View {
        ToDoList(viewModel: ToDoViewModelAsync(), isEditing: .constant(false), editingTodoID: .constant(nil), changedText: .constant(""))
    }
}
