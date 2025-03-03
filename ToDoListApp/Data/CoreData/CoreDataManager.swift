//
//  CoreDataManager.swift
//  ToDoListApp
//
//  Created by 김동현 on 3/2/25.
//

import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()

    var persistentContainer: NSPersistentContainer

    private init() {
        guard let modelURL = Bundle(for: CoreDataManager.self).url(forResource: "ToDoListApp", withExtension: "momd"),
              let managedObjectModel = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("❌ CoreData 모델을 찾을 수 없습니다.")
        }

        persistentContainer = NSPersistentContainer(name: "ToDoListApp", managedObjectModel: managedObjectModel)

        persistentContainer.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("❌ CoreData 로드 실패: \(error.localizedDescription)")
            }
        }
    }

    var context: NSManagedObjectContext {
        return persistentContainer.viewContext
    }

    /// ✅ CoreData 변경사항 저장 함수
    func saveContext() {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                print("✅ CoreData 변경 사항 저장 성공")
            } catch {
                print("❌ CoreData 저장 실패: \(error.localizedDescription)")
            }
        }
    }
}
