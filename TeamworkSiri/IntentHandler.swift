//
//  IntentHandler.swift
//  TeamworkSiri
//
//  Created by Nikolay Derkach on 10/24/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Intents
import TeamworkProjectCore

class IntentHandler: INExtension {

    override func handler(for intent: INIntent) -> Any {
        // This is the default implementation.  If you want different objects to handle different intents,
        // you can override this and return the handler you want for that particular intent.

        return self
    }

    func createTasks(fromTitles taskTitles: [String]) -> [INTask] {
        var tasks: [INTask] = []
        tasks = taskTitles.map { taskTitle -> INTask in
            let task = INTask(title: INSpeakableString(spokenPhrase: taskTitle),
                              status: .notCompleted,
                              taskType: .completable,
                              spatialEventTrigger: nil,
                              temporalEventTrigger: nil,
                              createdDateComponents: nil,
                              modifiedDateComponents: nil,
                              identifier: nil)
            return task
        }
        return tasks
    }
}

extension IntentHandler : INAddTasksIntentHandling {

    public func handle(intent: INAddTasksIntent,
                       completion: @escaping (INAddTasksIntentResponse) -> Swift.Void) {

        let dispatchGroup = DispatchGroup()

        var tasks: [INTask] = []
        var addedTasks: [INTask] = []

        if let taskTitles = intent.taskTitles {
            let taskTitlesStrings = taskTitles.map {
                taskTitle -> String in
                return taskTitle.spokenPhrase
            }
            tasks = createTasks(fromTitles: taskTitlesStrings)
            for task in tasks {
                dispatchGroup.enter()
                TaskManager.sharedInstance.addTask (withName: task.title.spokenPhrase) { (success) in
                    if success {
                        addedTasks.append(task)
                    }
                    dispatchGroup.leave()
                }
            }
        }

        dispatchGroup.notify(queue: .main) {
            let response = INAddTasksIntentResponse(code: addedTasks.isEmpty ? .failure : .success , userActivity: nil)
            response.addedTasks = addedTasks
            completion(response)
        }
    }
}

extension IntentHandler : INSetTaskAttributeIntentHandling {

    public func handle(intent: INSetTaskAttributeIntent,
                       completion: @escaping (INSetTaskAttributeIntentResponse) -> Swift.Void) {

        guard let title = intent.targetTask?.title else {
            completion(INSetTaskAttributeIntentResponse(code: .failure, userActivity: nil))
            return
        }

        let status = intent.status

        if status == .completed {
            TaskManager.sharedInstance.finishTask(withName: title.spokenPhrase) { (success, taskName) in
                let response = INSetTaskAttributeIntentResponse(code: success ? .success : .failure, userActivity: nil)

                // display the task name which was recognised with fuzzy matching
                var taskTitle: String?
                if let taskName = taskName {
                    taskTitle = taskName
                } else {
                    taskTitle = intent.targetTask?.title.spokenPhrase
                }

                let modifiedTask = INTask(title: INSpeakableString(spokenPhrase: taskTitle!), status: (intent.targetTask?.status)!, taskType: (intent.targetTask?.taskType)!, spatialEventTrigger: intent.targetTask?.spatialEventTrigger, temporalEventTrigger: intent.targetTask?.temporalEventTrigger, createdDateComponents: intent.targetTask?.createdDateComponents, modifiedDateComponents: intent.targetTask?.modifiedDateComponents, identifier: intent.targetTask?.identifier)

                response.modifiedTask = modifiedTask
                completion(response)
            }
        }
    }
}
