//
//  ViewController.swift
//  TeamworkProject
//
//  Created by Nikolay Derkach on 10/20/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

import Siesta

let projectId = "339988"
let taskListId = 1413042

class MainViewController: UIViewController {

    let projectResource: Resource? = TeamworkAPI.tasklist(withId: taskListId)

    override func viewDidLoad() {
        super.viewDidLoad()

        projectResource?.addObserver(self).loadIfNeeded()
    }
}

extension MainViewController: ResourceObserver {
    func resourceChanged(_ resource: Resource, event: ResourceEvent) {
        guard let result: TaskResult = projectResource?.typedContent() else {
            return
        }

        for task in result.items {
            print(task.id)
        }

    }
}
