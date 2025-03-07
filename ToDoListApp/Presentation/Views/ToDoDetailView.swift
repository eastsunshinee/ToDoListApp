//
//  ToDoDetailView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/6/25.
//

import SwiftUI

struct ToDoDetailView: View {
    let todo: ToDoItem
    @State private var isCompleted: Bool

    init(todo: ToDoItem) {
        self.todo = todo
        _isCompleted = State(initialValue: todo.isCompleted)
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Text(todo.title)
                .font(.title)
                .bold()

            if let details = todo.details, !details.isEmpty {
                Text(details)
                    .foregroundColor(.secondary)
            } else {
                Text("세부 내용이 없습니다.")
                    .foregroundColor(.gray)
            }

            HStack {
                Text("완료 상태:")
                Toggle("", isOn: $isCompleted)
            }
            .padding()

            Spacer()

            Button(action: {
                // 완료 상태 변경 로직 추가 필요
            }) {
                Text("변경 사항 저장")
                    .font(.title3)
                    .foregroundColor(.white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(isCompleted ? Color.green : Color.blue)
                    .cornerRadius(8)
            }
            .padding()

        }
        .padding()
        .navigationTitle("할 일 상세")
    }
}

#Preview {
    ToDoDetailView(todo: ToDoItem(id: UUID(), title: "테스트 제목", details: "테스트 내용", isCompleted: false, createdAt: Date(), dueDate: nil))
}
