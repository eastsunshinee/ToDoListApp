//
//  ToDoRepository.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/3/25.
//

import Foundation
import Combine

protocol ToDoRepository {
    func fetchToDos() -> AnyPublisher<[ToDoItem], Error>
    func saveToDo(_ item: ToDoItem) -> AnyPublisher<Void, Error>
    func deleteToDo(_ id: UUID) -> AnyPublisher<Void, Error>
}
