//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager() // 싱글톤 인스턴스

    let persistentContainer: NSPersistentContainer
    var context: NSManagedObjectContext { persistentContainer.viewContext }

    private init() {
        persistentContainer = NSPersistentContainer(name: "ToDoListApp")
        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ CoreData 로드 실패: \(error.localizedDescription)")
            }
        }
    }

    /// 테스트 전용 인스턴스
    internal init(inMemory: Bool = false) {
        persistentContainer = NSPersistentContainer(name: "ToDoListApp")

        if inMemory {
            persistentContainer.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }

        persistentContainer.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ CoreData 로드 실패 (테스트 모드): \(error.localizedDescription)")
            }
        }
    }

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print("❌ CoreData 저장 오류: \(error.localizedDescription)")
            }
        }
    }
}
