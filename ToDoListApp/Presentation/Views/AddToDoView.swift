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
        ZStack {
            Color.myBackground.ignoresSafeArea() // ✅ 배경 컬러 적용

            VStack(spacing: 20) {
                Text("새로운 할 일 추가")
                    .font(.title)
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
                }
                .padding(.horizontal, 20)

                Spacer()

                // ✅ 추가 버튼 (스타일 적용)
                Button(action: {
                    viewModel.addToDo(title: title, details: details.isEmpty ? nil : details)
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Text("추가하기")
                        .font(.headline)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(title.isEmpty ? Color.gray : Color.myDestructive)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                }
                .disabled(title.isEmpty)
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            .padding(.top, 40)
        }
    }
}

#Preview {
    AddToDoView(viewModel: ToDoListViewModel(useCase: ToDoUseCaseImpl(repository: MockToDoRepository(mockData: []))))
}
