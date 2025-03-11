//
//  ToDoDetailView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/6/25.
//

import SwiftUI

struct ToDoDetailView: View {
    @ObservedObject var viewModel: ToDoListViewModel
    @State private var title: String
    @State private var details: String
    @State private var isCompleted: Bool
    @Environment(\.presentationMode) var presentationMode

    let todo: ToDoItem

    init(todo: ToDoItem, viewModel: ToDoListViewModel) {
        self.todo = todo
        self.viewModel = viewModel
        _title = State(initialValue: todo.title)
        _details = State(initialValue: todo.details ?? "")
        _isCompleted = State(initialValue: todo.isCompleted)
    }

    var body: some View {
        ZStack {
            Color.myBackground.ignoresSafeArea()

            VStack(spacing: 20) {
                Text("할 일 상세")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.myTextPrimary)

                VStack(spacing: 16) {
                    TextField("제목", text: $title)
                        .padding()
                        .background(Color.myContainer)
                        .cornerRadius(10)
                        .foregroundColor(.myTextPrimary)

                    TextField("세부 사항", text: $details)
                        .padding()
                        .background(Color.myContainer)
                        .cornerRadius(10)
                        .foregroundColor(.myTextSecondary)

                    Toggle("완료 상태", isOn: $isCompleted)
                        .toggleStyle(SwitchToggleStyle(tint: .myPrimaryBlue))
                        .padding()
                        .background(Color.myContainer)
                        .cornerRadius(10)
                }
                .padding(.horizontal, 20)

                Spacer()

                HStack(spacing: 12) {
                    Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("취소")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.gray)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }

                    Button(action: {
                        let updatedToDo = ToDoItem(
                            id: todo.id, title: title, details: details.isEmpty ? nil : details,
                            isCompleted: isCompleted, createdAt: todo.createdAt, dueDate: todo.dueDate
                        )
                        withAnimation {
                            viewModel.updateToDo(updatedToDo)
                        }
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Text("저장")
                            .font(.headline)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.myDestructive)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    let mockToDo = ToDoItem(id: UUID(), title: "SwiftUI 학습", details: "Combine & MVVM 연습", isCompleted: false, createdAt: Date(), dueDate: nil)
    let mockRepository = MockToDoRepository(mockData: [mockToDo])
    let mockViewModel = ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: mockRepository))

    return ToDoDetailView(todo: mockToDo, viewModel: mockViewModel)
}
