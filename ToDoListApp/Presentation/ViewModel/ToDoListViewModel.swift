//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/5/25.
//

import Foundation
import SwiftUI
import Combine

/// 주요 기능: 할 일 목록 가져오기, 추가, 삭제, 완료 상태 토글
final class ToDoListViewModel: ObservableObject {

    // MARK: - Properties
    @Published var toDos: [ToDoItem] = []
    @Published var showAddToDo: Bool = false

    private let useCase: ToDoUseCase
    private var cancellables: Set<AnyCancellable> = []

    // MARK: - Initialization
    init(useCase: ToDoUseCase) {
        self.useCase = useCase
        fetchToDos()
    }

    // MARK: - Public Methods
    /// 할 일 목록 가져오기
    func fetchToDos() {
        useCase.fetchToDos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
#if DEBUG
                    print("❌ 할 일 목록 가져오기 실패: \(failure)")
#endif
                }
            }, receiveValue: { [weak self] fetchedToDos in
                DispatchQueue.main.async {
                    self?.toDos = fetchedToDos
                }
            })
            .store(in: &cancellables)
    }

    /// 할 일 추가
    func addToDo(title: String, details: String?) {
        let newToDo = ToDoItem(id: UUID(), title: title, details: details, isCompleted: false, createdAt: Date(), dueDate: nil)
        useCase.saveToDo(newToDo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
#if DEBUG
                    print("❌ 할 일 추가 실패: \(failure)")
#endif
                }
            }, receiveValue: { [weak self] in
                guard let self = self else { return }
                self.toDos.append(newToDo)
                self.showAddToDo = false
            })
            .store(in: &cancellables)
    }

    /// 할 일 삭제
    func deleteToDo(id: UUID) {
        guard let index = toDos.firstIndex(where: { $0.id == id }) else { return }
        toDos.remove(at: index)
        useCase.deleteToDo(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
#if DEBUG
                    print("❌ 할 일 삭제 실패: \(error)")
#endif
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }

    /// 할 일 수정
    func updateToDo(_ todo: ToDoItem) {
        guard let index = toDos.firstIndex(where: { $0.id == todo.id }) else { return }
        toDos[index] = todo
        useCase.saveToDo(todo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
#if DEBUG
                    print("❌ 할 일 업데이트 실패: \(failure)")
#endif
                }
            }, receiveValue: { })
            .store(in: &cancellables)
    }
}
