//
//  CoreDataToDoRepository.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/3/25.
//

import Foundation
import Combine
import CoreData

final class CoreDataToDoRepository: ToDoRepository {
    private let coredataManager: CoreDataManager

    init(coredataManager: CoreDataManager = .shared) {
        self.coredataManager = coredataManager
    }

    func fetchToDos() -> AnyPublisher<[ToDoItem], any Error> {
        Future { promise in
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            do {
                let results = try self.coredataManager.context.fetch(fetchRequest)
                let toDoItems = results.map { $0.toDomainModel() }
                promise(.success(toDoItems))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    
    func saveToDo(_ item: ToDoItem) -> AnyPublisher<Void, any Error> {
        Future { promise in
            let toDoEntity = ToDoEntity(context: self.coredataManager.context)
            toDoEntity.id = item.id
            toDoEntity.title = item.title
            toDoEntity.details = item.details
            toDoEntity.isCompleted = item.isCompleted
            toDoEntity.createdAt = item.createdAt
            toDoEntity.dueDate = item.dueDate

            self.coredataManager.saveContext()
            promise(.success(()))
        }.eraseToAnyPublisher()
    }

    func deleteToDo(_ id: UUID) -> AnyPublisher<Void, any Error> {
        Future { promise in
            let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", id as CVarArg)

            do {
                let results = try self.coredataManager.context.fetch(fetchRequest)
                results.forEach { self.coredataManager.context.delete($0) }
                self.coredataManager.saveContext()
                promise(.success(()))
            } catch {
                promise(.failure(error))
            }
        }.eraseToAnyPublisher()
    }
    

}
