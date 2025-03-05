//
//  AddToDoView.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/5/25.
//

import SwiftUI

struct AddToDoView: View {
    @Environment(\.presentationMode) var presentationMode
    @State private var title: String = ""
    @State private var details: String = ""
    let viewModel: ToDoListViewModel

    var body: some View {
        Form {
            Section(header: Text("할 일")) {
                TextField("제목", text: $title)
                TextField("세부 사항", text: $details)
            }

            Button(action: {
                viewModel.addToDo(title: title, details: details.isEmpty ? nil : details)
                presentationMode.wrappedValue.dismiss()
            }) {
                Text("추가하기")
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
            }
            .disabled(title.isEmpty)
        }
        .navigationTitle("새로운 할 일 추가")
    }
}


#Preview {
    AddToDoView(viewModel: ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: CoreDataToDoRepository())))

}

