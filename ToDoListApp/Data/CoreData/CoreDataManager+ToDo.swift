//
//  CoreDataManager+ToDo.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import CoreData

extension CoreDataManager {

    // CREATE
    /// To-Do 항목을 저장
    /// - Parameters:
    ///   - title: 할 일 제목
    ///   - details: 할 일 세부 내용(선택)
    ///   - dueDate: 마감 기한(선택)
    func createToDo(title: String, details: String?, dueDate: Date?) {
        let context = self.context
        let toDo = ToDoEntity(context: context)
        toDo.id = UUID()
        toDo.title = title
        toDo.details = details
        toDo.isCompleted = false
        toDo.createdAt = Date()
        toDo.dueDate = dueDate
        saveContext()
    }
    
    /// 저장된 To-Do 항목들 가져옴
    /// - Returns: ToDoItem 배열
    func fetchToDos() -> [ToDoItem] {
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]

        do {
            let result = try context.fetch(request)
            return result.map { $0.toDomainModel() }
        } catch {
            print("Failed to fetch ToDos: \(error.localizedDescription)")
            return[]
        }
    }
    
    /// 특정 ID의 To-Do 항목 삭제
    /// - Parameter id: 삭제할 To-Do 항목의 UUID
    func deleteToDo(_ id: UUID) {
        let request = NSFetchRequest<ToDoEntity>(entityName: "ToDoEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)

        do {
            let result = try context.fetch(request)
            if let todo = result.first {
                context.delete(todo)
                saveContext()
            }
        } catch {
            print("Failed to delete ToDo: \(error.localizedDescription)")
        }
    }
}

