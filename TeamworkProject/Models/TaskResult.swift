//
//  TaskContent.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/20/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

struct TaskResult: Decodable {
    let items: [Task]

    enum CodingKeys: String, CodingKey {
        case items = "todo-items"
    }
}
