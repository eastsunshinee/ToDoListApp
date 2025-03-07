//
//  ToDoItem.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import Foundation

struct ToDoItem: Identifiable, Codable, Equatable {
    let id: UUID
    let title: String
    let details: String?
    var isCompleted: Bool
    var createdAt: Date
    var dueDate: Date?

    init(id: UUID, title: String, details: String?, isCompleted: Bool, createdAt: Date, dueDate: Date? = nil) {
        self.id = id
        self.title = title
        self.details = details
        self.isCompleted = isCompleted
        self.createdAt = createdAt
        self.dueDate = dueDate
    }
}
