//
//  ToDoEntity.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import CoreData

@objc(ToDoEntity)
public class ToDoEntity: NSManagedObject {
    @NSManaged public var id: UUID
    @NSManaged public var title: String
    @NSManaged public var details: String?
    @NSManaged public var isCompleted: Bool
    @NSManaged public var createdAt: Date
    @NSManaged public var dueDate: Date?
}

extension ToDoEntity {
    func toDomainModel() -> ToDoItem {
        return ToDoItem(
            id: self.id,
            title: self.title,
            details: self.details ?? "",
            isCompleted: self.isCompleted,
            createdAt: self.createdAt,
            dueDate: self.dueDate
        )
    }
}
