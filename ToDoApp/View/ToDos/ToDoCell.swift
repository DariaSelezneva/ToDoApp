//
//  ToDoCell.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

struct ToDoCell: View {
    
    let todo : Todo
    
    let isEditing: Bool
    @State var changedText: String = ""
    
    @State var showsValidationWarning : Bool = false
    
    let onTapChecked: () -> ()
    let onTapSave: (String) -> ()
    
    init(todo: Todo, isEditing: Bool, onTapChecked: @escaping () -> (), onTapSave: @escaping (String) -> ()) {
        self.todo = todo
        self.isEditing = isEditing
        self._changedText = State(wrappedValue: todo.title)
        self.onTapChecked = onTapChecked
        self.onTapSave = onTapSave
    }
    
    var body: some View {
        HStack {
            if isEditing {
                TextField("Enter todo", text: $changedText)
                    .frame(height: 50)
                    .padding(.leading)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.appLightGray))
                Spacer()
                Button("Save") {
                    let text = changedText.withoutExtraSpaces()
                    guard !text.isEmpty, text.count > 3, text.count < 160 else {
                        showsValidationWarning = true
                        return
                    }
                    onTapSave(changedText)
                }
                .alert("Can't save an empty todo", isPresented: $showsValidationWarning) {}
            }
            else {
                Text(todo.title)
                Spacer()
                Button {
                    onTapChecked()
                } label: {
                    let name = todo.isReady ? "checkmark.circle" : "circle"
                    Image(systemName: name)
                        .font(.system(size: 32))
                }
                .frame(width: 50, height: 50)
            }
        }
        .frame(height: 78)
    }
}

struct ToDoCell_Previews: PreviewProvider {
    static var previews: some View {
        ToDoCell(todo: Todo.sample[0], isEditing: true, onTapChecked: {}, onTapSave: {_ in })
            .previewLayout(.sizeThatFits)
    }
}
