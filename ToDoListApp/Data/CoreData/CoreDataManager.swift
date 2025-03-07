//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    let context: NSManagedObjectContext

    private init() {
        let container = NSPersistentContainer(name: "ToDoListApp")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ CoreData 로드 실패: \(error.localizedDescription)")
            }
        }
        self.context = container.viewContext
    }

    func saveContext() {
        do {
            try context.save()
        } catch {
            print("❌ CoreData 저장 실패: \(error.localizedDescription)")
        }
    }
}
