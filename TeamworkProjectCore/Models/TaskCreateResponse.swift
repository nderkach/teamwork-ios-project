//
//  TaskCreateResponse.swift
//  TeamworkProjectCore
//
//  Created by Nikolay Derkach on 10/26/17.
//  Copyright © 2017 Nikolay Derkach. All rights reserved.
//

struct TaskCreateResponse: Decodable {
    let affectedTaskIds: String
    let id: String
    let status: String

    enum CodingKeys: String, CodingKey {
        case affectedTaskIds
        case id
        case status = "STATUS"
    }
}
