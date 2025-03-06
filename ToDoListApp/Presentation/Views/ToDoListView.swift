//
//  ToDoListView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/5/25.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject private var viewModel: ToDoListViewModel

    init(viewModel: ToDoListViewModel = ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: CoreDataToDoRepository()))) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            VStack {
                if viewModel.toDos.isEmpty {
                    VStack {
                        Text("할 일이 없습니다.")
                            .foregroundColor(.gray)
                            .font(.headline)
                            .padding()

                        Button(action: {
                            viewModel.showAddToDo = true
                        }) {
                            Text("새로운 할 일 추가")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(Color.blue)
                                .cornerRadius(8)
                        }
                        .padding()
                    }
                } else {
                    List {
                        ForEach(viewModel.toDos, id: \.id) { todo in
                            NavigationLink(destination: ToDoDetailView(todo: todo)) {
                                HStack {
                                    Text(todo.title)
                                    Spacer()
                                    if todo.isCompleted {
                                        Image(systemName: "checkmark.circle.fill")
                                            .foregroundColor(.green)
                                    }
                                }
                            }
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
                }
            }
            .navigationTitle("할 일 목록")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        viewModel.showAddToDo = true
                    }) {
                        Image(systemName: "plus")
                    }
                }
            }
            .sheet(isPresented: $viewModel.showAddToDo) {
                AddToDoView(viewModel: viewModel)
            }
        }
    }
}

#Preview {
    ToDoListView()
}
