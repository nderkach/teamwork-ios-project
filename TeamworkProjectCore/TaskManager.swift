//
//  TaskManager.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/25/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Siesta

let projectId = "339988"

public class TaskManager {

    public static let sharedInstance = TaskManager()
    var taskResource: Resource?

    public func addTask(withName taskName: String) {
//        TeamworkAPI.addTaskToTaskList(withId: taskListId, content: taskName)
    }

    public func finishTask(withName taskName: String, completion: @escaping (Bool) -> Swift.Void) {
        DispatchQueue.main.async {
            TeamworkAPI.finishTask(withName: taskName, completion: completion)
        }
    }
}

extension TaskManager: ResourceObserver {
    public func resourceChanged(_ resource: Resource, event: ResourceEvent) {

    }
}
