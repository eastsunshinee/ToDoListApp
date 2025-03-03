//
//  CoreDataManagerTests.swift
//  ToDoListAppTests
//
//  Created by 김동현 on 3/2/25.
//

import XCTest
import CoreData
@testable import ToDoListApp

final class CoreDataManagerTests: XCTestCase {

    var coreDataManager: CoreDataManager!
    var context: NSManagedObjectContext!

    override func setUp() {
        super.setUp()
        coreDataManager = CoreDataManager.shared
        context = coreDataManager.context
        deleteAllData() // ✅ 기존 데이터 삭제 후 테스트 실행
    }

    override func tearDown() {
        deleteAllData() // ✅ 테스트 종료 후 데이터 삭제
        coreDataManager = nil
        context = nil
        super.tearDown()
    }

    /// ✅ CoreData 모든 데이터 삭제 (테스트 격리 보장)
    private func deleteAllData() {
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        do {
            let results = try context.fetch(fetchRequest)
            for object in results {
                context.delete(object)
            }
            coreDataManager.saveContext() // 변경 사항 저장
        } catch {
            print("❌ CoreData 초기화 실패: \(error.localizedDescription)")
        }
    }

    /// ✅ 새로운 ToDo 저장 테스트
    func testSaveToDo() {
        let newToDo = ToDoEntity(context: context)
        newToDo.id = UUID()
        newToDo.title = "Test Task"
        newToDo.details = "This is a test task."
        newToDo.isCompleted = false
        newToDo.createdAt = Date()
        newToDo.dueDate = nil

        coreDataManager.saveContext()

        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        let fetchedToDos = try? context.fetch(fetchRequest)

        XCTAssertNotNil(fetchedToDos)
        XCTAssertEqual(fetchedToDos?.count, 1) // ✅ 기존 데이터 삭제 후 1개만 있어야 함
        XCTAssertEqual(fetchedToDos?.first?.title, "Test Task")
    }

    /// ✅ 저장된 ToDo 조회 테스트
    func testFetchToDos() {
        // Given
        let newToDo1 = ToDoEntity(context: context)
        newToDo1.id = UUID()
        newToDo1.title = "Task 1"
        newToDo1.details = "First test task."
        newToDo1.isCompleted = false
        newToDo1.createdAt = Date()
        newToDo1.dueDate = nil

        let newToDo2 = ToDoEntity(context: context)
        newToDo2.id = UUID()
        newToDo2.title = "Task 2"
        newToDo2.details = "Second test task."
        newToDo2.isCompleted = true
        newToDo2.createdAt = Date()
        newToDo2.dueDate = nil

        coreDataManager.saveContext()

        // When
        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "title", ascending: true)] // ✅ 정렬 추가
        let fetchedToDos = try? context.fetch(fetchRequest)

        // Then
        XCTAssertNotNil(fetchedToDos)
        XCTAssertEqual(fetchedToDos?.count, 2)
        XCTAssertEqual(fetchedToDos?.first?.title, "Task 1") // ✅ 정렬 순서 확인
        XCTAssertEqual(fetchedToDos?.last?.title, "Task 2")
    }

    /// ✅ 저장된 ToDo 삭제 테스트
    func testDeleteToDo() {
        // Given
        let newToDo = ToDoEntity(context: context)
        newToDo.id = UUID()
        newToDo.title = "Task to delete"
        newToDo.details = "Task will be deleted."
        newToDo.isCompleted = false
        newToDo.createdAt = Date()
        newToDo.dueDate = nil

        coreDataManager.saveContext()

        let fetchRequest: NSFetchRequest<ToDoEntity> = ToDoEntity.fetchRequest()
        let fetchedToDosBefore = try? context.fetch(fetchRequest)
        XCTAssertEqual(fetchedToDosBefore?.count, 1) // 저장된 데이터 확인

        // When
        if let toDoToDelete = fetchedToDosBefore?.first {
            context.delete(toDoToDelete)
            coreDataManager.saveContext()
        }

        // Then
        let fetchedToDosAfter = try? context.fetch(fetchRequest)
        XCTAssertEqual(fetchedToDosAfter?.count, 0) // 삭제 후 데이터 없음 확인
    }
}
