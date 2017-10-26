//
//  TeamworkProjectCoreTests.swift
//  TeamworkProjectCoreTests
//
//  Created by Nikolay Derkach on 10/26/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import XCTest

@testable import TeamworkProjectCore

class TeamworkProjectCoreTests: XCTestCase {

    var taskManager: TaskManager?
    var createdTaskIds: [Int] = []
    
    override func setUp() {
        super.setUp()

        taskManager = TaskManager.sharedInstance
        let promise = expectation(description: "Wait for creating a mock task")

        taskManager?.addTask(withName: "Apples") { (success, taskId) in
            if success, let taskId = taskId {
                self.createdTaskIds.append(taskId)
                promise.fulfill()
            }
        }

        waitForExpectations(timeout: 5, handler: nil)
    }
    
    func testAddSingleTask() {
        let promise = expectation(description: "Wait for adding task")
        taskManager?.addTask(withName: "Oranges") { (success, taskId) in
            XCTAssertTrue(success)
            if let taskId = taskId {
                self.createdTaskIds.append(taskId)
            }
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testMarkTaskAsCompleted() {
        let promise = expectation(description: "Wait for adding task")
        taskManager?.finishTask(withName: "Apple") { (success, taskName) in
            XCTAssertEqual(taskName, "Apples")
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    func testMarkTaskAsCompletedFuzzy() {
        let promise = expectation(description: "Wait for adding task")
        taskManager?.finishTask(withName: "Applesauce") { (success, taskName) in
            XCTAssertTrue(success)
            XCTAssertEqual(taskName, "Apples")
            promise.fulfill()
        }
        waitForExpectations(timeout: 5, handler: nil)
    }

    override func tearDown() {

        let promise = expectation(description: "Wait for removing mock tasks")
        let dispatchGroup = DispatchGroup()

        for taskId in createdTaskIds {
            dispatchGroup.enter()
            taskManager?.removeTask(withId: taskId) { _ in
                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .main) {
            promise.fulfill()
        }

        waitForExpectations(timeout: 5, handler: nil)

        super.tearDown()
    }
}
