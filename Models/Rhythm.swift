//
//  Rhythm.swift
//  MorningDew
//
//  Created by Son Cao on 18/1/2024.
//

import Foundation
import SwiftData

@Model
class Rhythm {
    var name: String
    var emoji: String
    
    // If a Rhythm is deleted, then delete all tasks associated.
    // @Relationship(deleteRule: .cascade, inverse: \TaskItem.rhythm) var tasks: [TaskItem]
    
    var tasks: [TaskItem]
    
    var totalMinutes: Double {
        var minutes = 0.0
        for task in tasks {
            minutes += task.minutes
        }
        return minutes
    }
    
    var totalSeconds: Int {
        return Int(totalMinutes * 60)
    }
    
    init(name: String, tasks: [TaskItem] = [TaskItem](), emoji: String = AppData.defaultEmoji) {
        self.name = name
        self.tasks = tasks
        self.emoji = emoji
    }
}
