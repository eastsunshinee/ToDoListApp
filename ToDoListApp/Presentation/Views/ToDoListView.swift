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
        ZStack {
            Color.myBackground.ignoresSafeArea()

            VStack {
                HStack {
                    Text("나의 할 일")
                        .font(.largeTitle)
                        .bold()
                        .foregroundColor(.myTextPrimary)
                    Spacer()
                    Button(action: {
                        viewModel.showAddToDo = true
                    }) {
                        Image(systemName: "plus")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .padding(12)
                            .background(Color.myDestructive)
                            .foregroundColor(.white)
                            .clipShape(Circle())
                            .shadow(radius: 5)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)

                if viewModel.toDos.isEmpty {
                    EmptyStateView()
                        .transition(.opacity)
                        .padding(.top, 50)
                } else {
                    List {
                        ForEach(viewModel.toDos, id: \.id) { todo in
                            ToDoRowView(
                                todo: todo,
                                toggleCompletion: { id in
                                    withAnimation {
                                        viewModel.toggleCompletion(for: id)
                                    }
                                },
                                deleteAction: { id in
                                    withAnimation {
                                        viewModel.deleteToDo(id: id)
                                    }
                                }
                            )
                            .listRowBackground(Color.myContainer)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete(perform: deleteToDo)
                    }
                    .listStyle(.plain)
//                    .transition(.opacity)
                }

                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.showAddToDo) {
            AddToDoView(viewModel: viewModel)
        }
    }

    /// 리스트에서 삭제하는 메서드
    private func deleteToDo(at offsets: IndexSet) {
        for index in offsets {
            let todo = viewModel.toDos[index]
            withAnimation {
                viewModel.deleteToDo(id: todo.id)
            }
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

