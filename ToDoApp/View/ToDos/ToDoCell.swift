//
//  ToDoCell.swift
//  ToDoApp
//
//  Created by Daria on 21.04.2022.
//

import SwiftUI

struct ToDoCell: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    let todo : Todo
    
    let isEditing: Bool
    let isCheckEnabled: Bool
    @Binding var changedText: String
    
    @State private var showsValidationWarning : Bool = false
    @State private var validationWarning : String = ""
    
    let onTapChecked: () -> ()
    let onTapSave: (String) -> ()
    let onTapCancel: () -> ()
    
    var body: some View {
        if isEditing {
            VStack {
                TextField("Enter todo", text: $changedText, onCommit: {
                    validateAndSave()
                })
                    .frame(height: 50)
                    .padding(.horizontal)
                    .background(RoundedRectangle(cornerRadius: 12).fill(Color.appLightGray.opacity(colorScheme == .light ? 1.0 : 0.2)))
                HStack {
                    Button("Cancel") {
                        onTapCancel()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderless)
                    Button("Save") {
                        validateAndSave()
                    }
                    .frame(maxWidth: .infinity)
                    .buttonStyle(.borderedProminent)
                    .alert(validationWarning, isPresented: $showsValidationWarning) {}
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
                .disabled(!isCheckEnabled)
                .scaleEffect(todo.isReady ? 1.1 : 1.0)
            }
        }
    }
    
    func validateAndSave() {
        let text = changedText.withoutExtraSpaces()
        changedText = text
        if text.isEmpty {
            validationWarning = "Can not save an empty todo"
            showsValidationWarning = true
        }
        else if text.count < 3 {
            validationWarning = "Too short title (4 characters min)"
            showsValidationWarning = true
        }
        else if text.count > 160 {
            validationWarning = "Too long title (160 characters max)"
            showsValidationWarning = true
        }
        else {
            onTapSave(text)
        }
    }
}

struct ToDoCell_Previews: PreviewProvider {
    static var previews: some View {
        ToDoCell(todo: Todo.sample[0], isEditing: true, isCheckEnabled: true, changedText: .constant(""), onTapChecked: {}, onTapSave: {_ in }, onTapCancel: {})
            .previewLayout(.sizeThatFits)
    }
}
