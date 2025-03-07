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

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.primaryColor)

                if let details = todo.details, !details.isEmpty {
                    Text(details)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
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
                    .frame(width: 30, height: 30)
                    .foregroundColor(todo.isCompleted ? .primaryColor : .gray)
                    .rotationEffect(.degrees(todo.isCompleted ? 360 : 0))
                    .scaleEffect(todo.isCompleted ? 1.2 : 1.0)
                    .animation(.spring(), value: todo.isCompleted)
            }
            .contentShape(Rectangle())
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.backgroundColor)
                .shadow(radius: 3)
        )
    }
}

#Preview {
    ToDoRowView(todo: ToDoItem(id: UUID(), title: "SwiftUI 학습", details: "Combine & MVVM 연습", isCompleted: false, createdAt: Date(), dueDate: nil),
                toggleCompletion: { _ in })
        .previewLayout(.sizeThatFits)
        .padding()
}
