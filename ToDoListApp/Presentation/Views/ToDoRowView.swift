//
//  ToDoRowView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/7/25.
//

import SwiftUI

struct ToDoRowView: View {
    let todo: ToDoItem
    var body: some View {
        HStack {
            // MARK: - 할 일 정보
            VStack(alignment: .leading, spacing: 5) {
                Text(todo.title)
                    .font(.headline)
                    .foregroundColor(.myTextPrimary)

                if let details = todo.details, !details.isEmpty {
                    Text(details)
                        .font(.subheadline)
                        .foregroundColor(.myTextSecondary)
                        .lineLimit(1)
                }
            }
            Spacer()
            // MARK: - 체크 상태 정보
            Button(action: {
                withAnimation {
                    
                }
            }) {
                Image(systemName: todo.isCompleted ? "checkmark.circle.fill" : "circle")
                    .resizable()
                    .frame(width: 28, height: 28)
                    .foregroundColor(todo.isCompleted ? .myDestructive : .gray)
            }
        }
        .padding(15)
        .background(Color.myContainer)
        .cornerRadius(12)
    }
}

#Preview {
    ToDoRowView(
        todo: ToDoItem(id: UUID(), title: "SwiftUI 학습", details: "Combine & MVVM 연습", isCompleted: false, createdAt: Date(), dueDate: nil)
    )
    .padding()
}


