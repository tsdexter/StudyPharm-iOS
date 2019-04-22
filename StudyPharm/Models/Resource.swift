//
//  Resource.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation

class Resource {
    let id: String
    let name: String
    let module: String
    let content: String
    
    init(id: String, name: String, module: String, content: String) {
        self.id = id
        self.name = name
        self.module = module
        self.content = content
    }
}
