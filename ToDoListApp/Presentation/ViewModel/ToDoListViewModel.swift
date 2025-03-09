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
    @Published var toDos: [ToDoItem] = [] // ✅ 상태를 즉시 반영
    @Published var showAddToDo: Bool = false

    private let useCase: ToDoUseCase
    private var cancellables: Set<AnyCancellable> = []

    init(useCase: ToDoUseCase) {
        self.useCase = useCase
        fetchToDos()
    }

    /// 할 일 목록 가져오기
    func fetchToDos() {
        useCase.fetchToDos()
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("❌ 할 일 목록 가져오기 실패: \(failure)")
                }
            }, receiveValue: { [weak self] fetchedToDos in
                DispatchQueue.main.async {
                    self?.toDos = fetchedToDos // ✅ 중복 추가 방지 (덮어쓰기)
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
                    print("❌ 할 일 추가 실패: \(failure)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchToDos()
                self?.showAddToDo = false
            })
            .store(in: &cancellables)
    }

    /// 할 일 삭제
    func deleteToDo(id: UUID) {
        guard let index = toDos.firstIndex(where: { $0.id == id }) else { return }

        withAnimation {
            toDos.remove(at: index) // ✅ UI에서 즉시 제거
        }

        useCase.deleteToDo(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ 할 일 삭제 실패: \(error)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchToDos() // ✅ 최신 데이터 유지
            })
            .store(in: &cancellables)
    }

    /// 완료 상태 토글
    func toggleCompletion(for id: UUID) {
        guard let index = toDos.firstIndex(where: { $0.id == id }) else { return }

        var updatedToDo = toDos[index]
        updatedToDo.isCompleted.toggle()

        useCase.saveToDo(updatedToDo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("❌ 할 일 상태 변경 실패: \(failure)")
                }
            }, receiveValue: { [weak self] in
                DispatchQueue.main.async {
                    self?.toDos[index] = updatedToDo // ✅ 중복 데이터 추가 없이 배열 갱신
                }
            })
            .store(in: &cancellables)
    }


    func updateToDo(_ todo: ToDoItem) {
        useCase.saveToDo(todo)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("❌ 할 일 업데이트 실패: \(failure)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchToDos()
            })
            .store(in: &cancellables)
    }
}
