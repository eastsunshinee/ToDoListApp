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
            ZStack {
                Color.myBackground.ignoresSafeArea()

                VStack {
                    // MARK: - 헤더 영역
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
                                .frame(width: 22, height: 22)
                                .padding(12)
                                .background(Color.myDestructive)
                                .foregroundColor(.white)
                                .clipShape(Circle())
                                .shadow(radius: 5)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    // MARK: - 할 일 목록
                    if viewModel.toDos.isEmpty {
                        EmptyStateView()
                            .transition(.opacity)
                            .padding(.top, 50)
                    } else {
                        List {
                            ForEach(viewModel.toDos, id: \.id) { todo in
                                NavigationLink(destination: ToDoDetailView(todo: todo, viewModel: viewModel)) {
                                    ToDoRowView(todo: todo)
                                }
                                .listRowBackground(Color.clear)
                                .listRowSeparator(.hidden)
                            }
                            .onDelete(perform: deleteToDo)
                        }
                        .listStyle(.plain)
                    }
                    Spacer()
                }
            }
        }
        .sheet(isPresented: $viewModel.showAddToDo) {
            AddToDoView(viewModel: viewModel)
        }
    }
    // MARK: - Methods
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
