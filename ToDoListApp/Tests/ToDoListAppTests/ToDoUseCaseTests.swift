//
//  ToDoUseCaseTests.swift
//  ToDoListAppTests
//
//  Created by 김동현 on 3/4/25.
//

import XCTest
import Combine
@testable import ToDoListApp

final class ToDoUseCaseTests: XCTestCase {

    var useCase: ToDoUseCaseImpl!
    var repository: MockToDoRepository!
    var cancellables: Set<AnyCancellable>!

    override func setUp() {
        super.setUp()
        repository = MockToDoRepository()
        useCase = ToDoUseCaseImpl(repository: repository)
        cancellables = []
    }

    override func tearDown() {
        useCase = nil
        repository = nil
        cancellables = nil
        super.tearDown()
    }

    func testFetchToDos() {
        let expectation = XCTestExpectation(description: "To-Doo 목록 가져오기")
        useCase.fetchToDos()
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("\(error.localizedDescription)")
                }

            }, receiveValue: { todos in
                XCTAssertEqual(todos.count, 2, "데이터 개수가 맞지 않음")
                expectation.fulfill()
            })
            .store(in: &cancellables)
        wait(for: [expectation], timeout: 2.0)
    }

    /// ✅ To-Do 저장 테스트
    func testSaveToDo() {
        let newToDo = ToDoItem(id: UUID(), title: "테스트 제목", details: "테스트 내용", isCompleted: false, createdAt: Date(), dueDate: nil)
        let expectation = XCTestExpectation(description: "To-Do 저장")

        useCase.saveToDo(newToDo)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("테스트 실패 - 저장 중 오류 발생: \(error)")
                }
            }, receiveValue: {
                self.useCase.fetchToDos()
                    .sink(receiveCompletion: { _ in }, receiveValue: { todos in
                        XCTAssertTrue(todos.contains { $0.id == newToDo.id }, "저장한 데이터가 존재하지 않음")
                        expectation.fulfill()
                    })
                    .store(in: &self.cancellables)
            })
            .store(in: &cancellables)

        wait(for: [expectation], timeout: 2.0)
    }

    /// ✅ To-Do 삭제 테스트
    func testDeleteToDo() {
        XCTAssertNotNil(repository.mockData.first, "삭제할 데이터가 없음")

        let deleteID = repository.mockData.first!.id
        let expectation = XCTestExpectation(description: "To-Do 삭제")

        useCase.deleteToDo(deleteID)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    XCTFail("테스트 실패 - 삭제 중 오류 발생: \(error)")
                }
            }, receiveValue: {
                self.useCase.fetchToDos()
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
