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
    
    @State var isShowingDeletionWarning : Bool = false
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
                        interactor.setAllCompleted()
                    }
                    Button("Mark all as active") {
                        interactor.setAllActive()
                    }
                    Button("Delete all completed") {
                        interactor.deleteAllCompleted()
                    }
                } label: {
                    Image(systemName: "ellipsis")
                        .font(.system(size: 32))
                }
                .frame(width: 50, height: 50)
                Button {
                    let todo = Todo(id: -1, title: "", isReady: false)
                    interactor.appState.todos.append(todo)
                    editingTodoID = -1
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
            List {
                ForEach(Array(zip(appState.todos.indices, appState.todos)), id: \.0) { index, todo in
                    ToDoCell(todo: todo, isEditing: todo.id == editingTodoID, onTapChecked: {
                        interactor.toggleToDo(todoID: todo.id)
                    }, onTapSave: { text in
                        interactor.saveToDo(todoID: todo.id, text: text)
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
                                isShowingDeletionWarning = true
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
                }
            }
            .alert(isPresented: $isShowingDeletionWarning) {
                Alert.taskDeletion {
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
