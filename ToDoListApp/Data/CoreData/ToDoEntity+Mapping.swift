//
//  ToDoEntity+Mapping.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/3/25.
//

import Foundation

extension ToDoEntity {
    /// CoreData 모델을 도메인 모델로 변환하는 함수
    func toDomainModel() -> ToDoItem {
        return ToDoItem(
            id: self.id ?? UUID(),
            title: self.title ?? "",
            details: self.details ?? "",
            isCompleted: self.isCompleted,
            createdAt: self.createdAt ?? Date(),
            dueDate: self.dueDate
        )
    }
}
