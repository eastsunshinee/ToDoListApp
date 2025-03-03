//
//  MockToDoRepository.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/3/25.
//

import Foundation
import Combine

final class MockToDoRepository: ToDoRepository {
    private(set) var mockData: [ToDoItem] = [
        ToDoItem(id: UUID(), title: "테스트 제목 01", details: "테스트 내용 01", isCompleted: false, createdAt: Date(), dueDate: nil)
        , ToDoItem(id: UUID(), title: "테스트 제목 02", details: "테스트 내용 02", isCompleted: true, createdAt: Date(), dueDate: nil)
    ]

    func fetchToDos() -> AnyPublisher<[ToDoItem], any Error> {
        Just(mockData)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func saveToDo(_ item: ToDoItem) -> AnyPublisher<Void, any Error> {
        mockData.append(item)
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
    
    func deleteToDo(_ id: UUID) -> AnyPublisher<Void, any Error> {
        mockData.removeAll { $0.id == id }
        return Just(())
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
