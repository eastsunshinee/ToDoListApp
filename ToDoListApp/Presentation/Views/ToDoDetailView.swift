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
    @ObservedObject var viewModel: ToDoListViewModel

    init(todo: ToDoItem, viewModel: ToDoListViewModel) {
        self.todo = todo
        self.viewModel = viewModel
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
                let updatedToDo = ToDoItem(
                    id: todo.id, title: todo.title, details: todo.details,
                    isCompleted: isCompleted, createdAt: todo.createdAt, dueDate: todo.dueDate
                )
                viewModel.updateToDo(updatedToDo) // ✅ ViewModel을 사용하여 업데이트
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
    let mockToDo = ToDoItem(id: UUID(), title: "SwiftUI 학습", details: "Combine & MVVM 연습", isCompleted: false, createdAt: Date(), dueDate: nil)
    let mockRepository = MockToDoRepository(mockData: [mockToDo])
    let mockViewModel = ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: mockRepository))

    ToDoDetailView(todo: mockToDo, viewModel: mockViewModel)
}
