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

let TeamworkAPI = _TeamworkAPI()

class _TeamworkAPI {

    // MARK: - Configuration

    private let service = Service(
        baseURL: baseURL,
        standardTransformers: [.text, .image])

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
        service.resource("/tasklists/\(taskListId)/tasks.json").request(.post, json: json).onSuccess() { _ in
            
            //
        }
    }

    func finishTask(withId taskId: Int) {
        service.resource("/tasks/\(taskId)/complete.json").request(.put).onSuccess() {_ in

        }
    }

}
