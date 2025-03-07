//
//  ToDoListView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/5/25.
//
import SwiftUI

struct ToDoListView: View {
    @ObservedObject var viewModel: ToDoListViewModel

    var body: some View {
        NavigationStack {
            VStack {
                if viewModel.toDos.isEmpty {
                    EmptyStateView(message: "할 일이 없습니다.\n새로운 할 일을 추가하세요.")
                } else {
                    List {
                        ForEach(viewModel.toDos, id: \.id) { todo in
                            ToDoRowView(todo: todo, toggleCompletion: viewModel.toggleCompletion)
                                .swipeActions(edge: .trailing) {
                                    Button(role: .destructive) {
                                        withAnimation {
                                            viewModel.deleteToDo(id: todo.id)
                                        }
                                    } label: {
                                        Label("삭제", systemImage: "trash")
                                    }
                                }
                        }
                    }
                    .listStyle(.insetGrouped)
                }
            }
            .navigationTitle("할 일 목록")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button {
                        // 할 일 추가 뷰로 이동하는 액션 추가 가능
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.primaryColor)
                            .font(.system(size: 24))
                    }
                }
            }
            .background(Color.backgroundColor.ignoresSafeArea())
        }
    }
}

#Preview {
    let mockToDoItems = [
        ToDoItem(id: UUID(), title: "SwiftUI 학습", details: "Combine & MVVM 연습", isCompleted: false, createdAt: Date(), dueDate: nil),
        ToDoItem(id: UUID(), title: "iOS 앱 개발", details: "ToDoList 프로젝트 개선", isCompleted: true, createdAt: Date(), dueDate: nil)
    ]

    let mockRepository = MockToDoRepository(mockData: mockToDoItems)
    let viewModel = ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: mockRepository))

    return ToDoListView(viewModel: viewModel)
}
