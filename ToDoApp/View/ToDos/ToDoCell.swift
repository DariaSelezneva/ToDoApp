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
    @Binding var changedText: String
    
    @State private var showsValidationWarning : Bool = false
    
    let onTapChecked: () -> ()
    let onTapSave: (String) -> ()
    let onTapCancel: () -> ()
    
//    init(todo: Todo, isEditing: Bool, changedText: Binding<String>, onTapChecked: @escaping () -> (), onTapSave: @escaping (String) -> (), onTapCancel: @escaping () -> ()) {
//        print("isEditing: \(isEditing), todo: \(todo)")
//        self.todo = todo
//        self.isEditing = isEditing
//        self.onTapChecked = onTapChecked
//        self.onTapSave = onTapSave
//        self.onTapCancel = onTapCancel
//    }
    
    var body: some View {
        if isEditing {
            VStack {
                TextField("Enter todo", text: $changedText, onCommit: {
                    validateAndSave()
                })
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.appLightGray))
                HStack {
                    Button("Cancel") {
//                        changedText = todo.text
                        onTapCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderless)
                    Button("Save") {
                        validateAndSave()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .alert("Invalid input", isPresented: $showsValidationWarning) {}
                }
                .padding(.all, 5)
            }
        }
        else {
            HStack {
                Text(todo.text)
                    .strikethrough(todo.isReady)
                Spacer()
                Button {
                    onTapChecked()
                } label: {
                    let name = todo.isReady ? "checkmark.circle" : "circle"
                    Image(systemName: name)
                        .font(.system(size: 32))
                        .padding(.vertical)
                }
                .scaleEffect(todo.isReady ? 1.1 : 1.0)
            }
        }
    }
    
    func validateAndSave() {
        let text = changedText.withoutExtraSpaces()
        changedText = text
        guard !text.isEmpty, text.count > 3, text.count < 160 else {
            showsValidationWarning = true
            return
        }
        onTapSave(text)
    }
}

struct ToDoCell_Previews: PreviewProvider {
    static var previews: some View {
        ToDoCell(todo: Todo.sample[0], isEditing: true, changedText: .constant(""), onTapChecked: {}, onTapSave: {_ in }, onTapCancel: {})
            .previewLayout(.sizeThatFits)
    }
}
