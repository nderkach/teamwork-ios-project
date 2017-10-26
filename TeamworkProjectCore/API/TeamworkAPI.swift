//
//  TeamworkAPI.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/20/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Siesta

let baseURL = "https://yat.teamwork.com"
let apiKey = "twp_TEbBXGCnvl2HfvXWfkLUlzx92e3T"

// TODO: add option to add task to arbitary task lists
let taskListId = 1413042

let TeamworkAPI = _TeamworkAPI()

class _TeamworkAPI {

    // MARK: - Configuration

    private let service = Service(
        baseURL: baseURL,
        standardTransformers: [.text, .image])

    private var taskNameMap: [String: Task] = [:]
    private var tasks: [Task]? {
        didSet {
            tasks?.forEach({ task in
                taskNameMap[task.content] = task
            })
        }
    }

    fileprivate init() {
        #if DEBUG
            LogCategory.enabled = [.network]
        #endif

        // –––––– Global configuration ––––––

        let jsonDecoder = JSONDecoder()

        service.configure("**") {
            let auth = "\(apiKey):X".data(using: String.Encoding.utf8)!
            $0.headers["Authorization"] = "Basic \(auth.base64EncodedString())"
        }

        // –––––– Mapping from specific paths to models ––––––

        service.configureTransformer("/projects.json") {
            try jsonDecoder.decode(ProjectResult.self, from: $0.content)
        }

        service.configureTransformer("/tasklists/*/tasks.json") {
            try jsonDecoder.decode(TaskResult.self, from: $0.content)
        }
    }

    // MARK: - Endpoint Accessors

    func projects() -> Resource {
        return service
            .resource("/projects.json")
    }

    func tasklist(withId id: Int) -> Resource {
        return service
            .resource("/tasklists/\(id)/tasks.json")
    }
    
    func addTaskToTaskList(withId taskListId: Int, content taskContent: String) {
        let json = [
            "todo-item": [
                "content": taskContent
            ]
        ]

        DispatchQueue.main.async {
            self.service.resource("/tasklists/\(taskListId)/tasks.json").request(.post, json: json).onSuccess() { _ in

                //
            }
        }
    }

    func finishTask(withName taskName: String, completion: @escaping (Bool) -> Swift.Void) {

            service.resource("/tasklists/\(taskListId)/tasks.json").request(.get).onSuccess() { entity in

                guard let result: TaskResult = entity.typedContent() else {
                    return
                }

                self.tasks = result.items

                guard let task = self.taskNameMap[taskName] else {
                    return completion(false)
                }

                self.service.resource("/tasks/\(task.id)/complete.json").request(.put).onSuccess() { _ in
                    completion(true)
                    }.onFailure { _ in
                        completion(false)
                }
            }
    }

}
