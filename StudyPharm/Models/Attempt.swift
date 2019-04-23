//
//  Attempt.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation

class Attempt {
    let id: String
    let module: String
    let quiz: String
    let name: String
    let score: Int
    let percent: Double
    
    init(id: String, module: String, quiz: String, name: String, score: Int, percent: Double) {
        self.id = id
        self.module = module
        self.quiz = quiz
        self.name = name
        self.score = score
        self.percent = percent
    }
    
    init(doc: [String: AnyObject]) {
        self.id = doc["id"] as! String
        self.module = doc["module"] as! String
        self.quiz = doc["quiz"] as! String
        self.name = doc["name"] as! String
        self.score = doc["score"] as! Int
        self.percent = doc["percent"] as! Double
    }
}
