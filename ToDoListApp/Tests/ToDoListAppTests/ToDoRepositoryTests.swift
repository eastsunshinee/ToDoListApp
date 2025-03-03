//
//  ToDoRepositoryTests.swift
//  ToDoListAppTests
//
//  Created by 김동현 on 3/3/25.
//

import XCTest
import Combine
@testable import ToDoListApp

final class ToDoRepositoryTests: XCTestCase {
    var repository: MockToDoRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        repository = MockToDoRepository()
        cancellables = []
    }

    override func tearDown() {
        repository = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchToDos() {
        let expectation = XCTestExpectation(description: "Fetch todos from repository")

        repository.fetchToDos()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("테스트 실패 - 가져오는 중 오류: \(error)")
                }
            }, receiveValue: { todos in
                XCTAssertEqual(todos.count, 2, "데이터 개수가 맞지 않음")
                XCTAssertEqual(todos.first?.title, "테스트 제목 01") // 특정 데이터 검증
                expectation.fulfill()
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testSaveToDo() {
        let newToDo = ToDoItem(id: UUID(), title: "테스트 제목 01", details: "테스트 내용 01", isCompleted: false, createdAt: Date(), dueDate: nil)
        let expectation = XCTestExpectation(description: "Save to repository")

        repository.saveToDo(newToDo)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("테스트 실패 - 저장 중 오류: \(error)")
                }
            }, receiveValue: {
                // 저장 후 fetch 실행하여 검증
                self.repository.fetchToDos()
                    .sink(receiveCompletion: { _ in }, receiveValue: { todos in
                        XCTAssertTrue(todos.contains { $0.id == newToDo.id }, "저장한 데이터가 존재하지 않음")
                        expectation.fulfill()
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    func testDeleteToDo() {
        XCTAssertNotNil(repository.mockData.first, "삭제할 데이터가 없음")

        let deleteID = repository.mockData.first!.id
        let expectation = XCTestExpectation(description: "Delete from repository")

        repository.deleteToDo(deleteID)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("테스트 실패 - 삭제 중 오류: \(error)")
                }
            }, receiveValue: {
                // 삭제 후 fetch 실행하여 검증
                self.repository.fetchToDos()
                    .sink(receiveCompletion: { _ in }, receiveValue: { todos in
                        XCTAssertFalse(todos.contains { $0.id == deleteID }, "삭제한 데이터가 아직 존재함")
                        expectation.fulfill()
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }
}
