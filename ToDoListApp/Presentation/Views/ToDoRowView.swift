//
//  ToDoRowView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/7/25.
//

import SwiftUI

struct ToDoRowView: View {
    let todo: ToDoItem
    let toggleCompletion: (UUID) -> Void
    let deleteAction: (UUID) -> Void

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 6) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(.myTextPrimary)
                    .padding(.bottom, 2)

                if let details = todo.details, !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundColor(.myTextSecondary)
                        .lineLimit(1)
                }
            }

            Spacer()

            Button(action: {
                withAnimation {
                    toggleCompletion(todo.id)
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(todo.isCompleted ? .myDestructive : .gray)
            }
            .contentShape(Rectangle())
        }
    }
}


#Preview {
    ToDoRowView(
        todo: ToDoItem(id: UUID(), title: "SwiftUI 학습", details: "Combine & MVVM 연습", isCompleted: false, createdAt: Date(), dueDate: nil),
        toggleCompletion: { _ in },
        deleteAction: { _ in }
    )
}
