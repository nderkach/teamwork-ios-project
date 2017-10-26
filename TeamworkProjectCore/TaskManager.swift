//
//  TaskManager.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/25/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Siesta

public class TaskManager {

    public static let sharedInstance = TaskManager()

    public func addTask(withName taskName: String, completion: @escaping (Bool, Int?) -> Swift.Void) {
        DispatchQueue.main.async {
            TeamworkAPI.addTaskToTaskList(withId: taskListId, content: taskName, completion: completion)
        }
    }

    public func finishTask(withName taskName: String, completion: @escaping (Bool, String?) -> Swift.Void) {
        DispatchQueue.main.async {
            TeamworkAPI.finishTask(withName: taskName, completion: completion)
        }
    }

    public func removeTask(withId taskId: Int, completion: @escaping (Bool) -> Swift.Void) {
        DispatchQueue.main.async {
            TeamworkAPI.removeTask(withId: taskId, completion: completion)
        }
    }
}
