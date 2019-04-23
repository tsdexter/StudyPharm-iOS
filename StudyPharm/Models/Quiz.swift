//
//  Quiz.swift
//  StudyPharm
//
//  Created by Thomas Dexter on 2019-04-22.
//  Copyright © 2019 Thomas Dexter. All rights reserved.
//

import Foundation

class Quiz {
    let name: String
    var attempts: [Attempt]
    
    init(name: String) {
        self.name = name
        self.attempts = [Attempt]()
    }
    
    func addAttempt(attempt: Attempt) {
        self.attempts.append(attempt)
    }
}
