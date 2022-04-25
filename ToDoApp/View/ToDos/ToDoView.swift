//
//  ToDoView.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

struct ToDoView: View {
    
    let interactor : TodoInteractor
    @EnvironmentObject var appState: AppState
    
    @State var editingTodoID: Int?
    
    @State var isShowingSingleDeletionWarning : Bool = false
    @State var isShowingAllReadyDeletionWarning : Bool = false
    @State var todoIDtoDelete : Int?
    
    var body: some View {
        VStack {
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
                .frame(width: 50, height: 50)
                .alert(isPresented: $isShowingAllReadyDeletionWarning) {
                    Alert.taskDeletion(title: "Do you want to delete all completed tasks?") {
                        interactor.deleteAllReady()
                    }
                }
                Button {
                    let todo = Todo(id: -1, text: "", isReady: false)
                    editingTodoID = -1
                    appState.todos.append(todo)
                } label: {
                    Image(systemName: "plus")
                        .font(.system(size: 32))
                }
                .frame(width: 50, height: 50)
                
            }
            .padding()
            HStack {
                Text("Active: \(appState.active), completed: \(appState.completed)")
                Spacer()
            }
            .padding(.horizontal, 20)
            ScrollViewReader { proxy in
                List {
                    ForEach(Array(zip(appState.todos.indices, appState.todos)), id: \.0) { index, todo in
                        ToDoCell(todo: todo, isEditing: todo.id == editingTodoID, onTapChecked: {
                            interactor.toggleToDo(todoID: todo.id)
                        }, onTapSave: { text in
                            interactor.saveToDo(todoID: todo.id, text: text)
                            editingTodoID = nil
                        }, onTapCancel: {
                            editingTodoID = nil
                        })
                        .onAppear {
                            if index == appState.todos.count - 1 {
                                interactor.loadMore()
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
                                    editingTodoID = todo.id
                                } label : {
                                    Image(systemName: "pencil")
                                }
                            }
                        }
                        .onChange(of: editingTodoID) { value in
                            if value == -1 {
                                proxy.scrollTo(appState.todos.count - 1)
                            }
                        }
                    }
                }
            }
            .alert(isPresented: $isShowingSingleDeletionWarning) {
                Alert.taskDeletion(title: "Do you want to delete this ToDo?") {
                    guard let id = todoIDtoDelete else { return }
                    interactor.deleteToDo(todoID: id)
                }
            }
        }
    }
}

struct ToDoView_Previews: PreviewProvider {
    static var previews: some View {
        ToDoView(interactor: TodoInteractor(appState: AppState()))
            .environmentObject(AppState())
    }
}
