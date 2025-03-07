//
//  SortOption.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/7/25.
//

import Foundation

enum SortOption: String, CaseIterable {
    case latest = "최신순"
    case oldest = "오래된 순"
    case incompleteFirst = "미완료 우선"

    var sortFunc: (ToDoItem, ToDoItem) -> Bool {
        switch self {
        case .latest:
            return { $0.createdAt > $1.createdAt}
        case .oldest:
            return { $0.createdAt < $1.createdAt}
        case .incompleteFirst:
            return { !$0.isCompleted && $1.isCompleted}
        }
    }
}
