//
//  TaskManager.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/25/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Siesta

let projectId = "339988"
let taskListId = 1413042

public class TaskManager {

    public static let sharedInstance = TaskManager()
//    let projectResource: Resource? = TeamworkAPI.tasklist(withId: taskListId)

    init() {

//        projectResource?.addObserver(self).loadIfNeeded()
    }

    public func addTask(_ taskName: String) {
        DispatchQueue.main.async {
            TeamworkAPI.addTaskToTaskList(withId: taskListId, content: taskName)
        }
    }
}

extension TaskManager: ResourceObserver {
    public func resourceChanged(_ resource: Resource, event: ResourceEvent) {
//        guard let result: TaskResult = projectResource?.typedContent() else {
//            return
//        }
//
//        for task in result.items {
//            print(task.id)
//        }

    }
}
