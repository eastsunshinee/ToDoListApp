//
//  ToDoUseCaseImpl.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/4/25.
//

import Foundation
import Combine

final class ToDoUseCaseImpl: ToDoUseCase {
    func fetchToDos() -> AnyPublisher<[ToDoItem], any Error> {
        repository.fetchToDos()
    }
    
    func saveToDo(_ todo: ToDoItem) -> AnyPublisher<Void, any Error> {
        repository.saveToDo(todo)
    }
    
    func deleteToDo(_ id: UUID) -> AnyPublisher<Void, any Error> {
        repository.deleteToDo(id)
    }
    
    private let repository: ToDoRepository

    init(repository: ToDoRepository) {
        self.repository = repository
    }


}
