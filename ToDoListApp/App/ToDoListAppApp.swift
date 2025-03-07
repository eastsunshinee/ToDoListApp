//
//  ToDoListAppApp.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import SwiftUI

@main
struct ToDoListAppApp: App {
    @StateObject private var viewModel = ToDoListViewModel(
        useCase: ToDoUseCaseImpl(repository: CoreDataToDoRepository())
    )

    var body: some Scene {
        WindowGroup {
            ToDoListView(viewModel: viewModel)
        }
    }
}
