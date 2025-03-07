//
//  ToDoListViewModel.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/5/25.
//

import Foundation
import Combine

/// 주요 기능: 할 일 목록 가져오기, 추가, 삭제, 완료 상태 토글
final class ToDoListViewModel: ObservableObject {
    @Published var toDos: [ToDoItem] = [] // 바인딩
    @Published var showAddToDo: Bool = false

    private let useCase: ToDoUseCase
    private var cancellables: Set<AnyCancellable> = []

    /// ViewModel 초기화
    /// - Parameter useCase: ToDoUseCase 주입
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
                self?.toDos = fetchedToDos
            })
            .store(in: &cancellables)
    }

    /// 할 일 추가
    /// - Parameters:
    ///   - title: 할 일 제목
    ///   - details: 할 일 내용(옵셔널)
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
    /// - Parameter id: 삭제할 할 일 ID
    func deleteToDo(id: UUID) {
        useCase.deleteToDo(id)
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    print("❌ 할 일 삭제 실패: \(error)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchToDos()
            })
            .store(in: &cancellables)
    }

    /// 완료 상태 토글
    func toggleCompletion(for id: UUID) {
        guard let index = toDos.firstIndex(where: { $0.id == id }) else { return }
        toDos[index].isCompleted.toggle()

        useCase.saveToDo(toDos[index])
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let failure) = completion {
                    print("❌ 할 일 상태 변경 실패: \(failure)")
                }
            }, receiveValue: { [weak self] in
                self?.fetchToDos() // CoreData 반영 후 UI 갱신
            })
            .store(in: &cancellables)
    }
}
