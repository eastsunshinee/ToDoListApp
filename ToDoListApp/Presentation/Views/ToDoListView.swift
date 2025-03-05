//
//  ToDoListView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/5/25.
//

import SwiftUI

struct ToDoListView: View {
    @StateObject private var viewModel: ToDoListViewModel

    /// 생성자
    /// - Parameter viewModel: ViewModel 주입
    init(viewModel: ToDoListViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.toDos) { toDo in
                    HStack {
                        VStack(alignment: .leading) {
                            Text(toDo.title)
                                .font(.headline)
                            if let details = toDo.details {
                                Text(details)
                                    .font(.subheadline)
                                    .foregroundColor(.gray)
                            }
                        }
                        Spacer()
                        Button(action: {
                            viewModel.deleteToDo(id: toDo.id)
                        }) {
                            Image(systemName: "trash")
                                .foregroundColor(.red)
                        }
                    }
                }
            }
            .navigationTitle("To-Do List")
            .toolbar {
                NavigationLink(destination: AddToDoView(viewModel: viewModel)) {
                    Image(systemName: "plus")
                }
            }
            .onAppear {
                viewModel.fetchToDos()
            }
        }
    }
}

#Preview {
    ToDoListView(viewModel: ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: CoreDataToDoRepository())))
}
