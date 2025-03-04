//
//  ToDoUseCase.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/4/25.
//

import Foundation
import Combine

protocol ToDoUseCase {
    func fetchToDos() -> AnyPublisher<[ToDoItem], Error>

    /// 항목 저장
    /// - Parameter todo: <#todo description#>
    /// - Returns: <#description#>
    func saveToDo(_ todo: ToDoItem) -> AnyPublisher<Void, Error>

    /// 특정 항목 삭제
    /// - Parameter id: <#id description#>
    /// - Returns: <#description#>
    func deleteToDo(_ id: UUID) -> AnyPublisher<Void, Error>
}
