//
//  TaskManager.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/25/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Siesta

let projectId = "339988"
// TODO: add option to add task to arbitary task lists
let taskListId = 1413042

public class TaskManager {

    public static let sharedInstance = TaskManager()
    var taskResource: Resource?
    var taskNameMap: [String: Task] = [:]
    var tasks: [Task]? {
        didSet {
            tasks?.forEach({ task in
                taskNameMap[task.content] = task
            })
        }
    }

    init() {
        DispatchQueue.main.async {
            self.taskResource = TeamworkAPI.tasklist(withId: taskListId)
            self.taskResource?.addObserver(self).load()
        }
    }

    public func addTask(withName taskName: String) {
        DispatchQueue.main.async {
            TeamworkAPI.addTaskToTaskList(withId: taskListId, content: taskName)
        }
    }

    public func finishTask(withName taskName: String) {
//        guard let task = taskNameMap[taskName] else {
//            return
//        }

        DispatchQueue.main.async {
//            TeamworkAPI.finishTask(withId: task.id)
            TeamworkAPI.finishTask(withId: 14471475)
        }
    }
}

extension TaskManager: ResourceObserver {
    public func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        guard let result: TaskResult = taskResource?.typedContent() else {
            return
        }

        tasks = result.items
    }
}
