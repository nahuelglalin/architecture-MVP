//
//  TaskDatabase.swift
//  Architecture-MVP
//
//  Created by Nahuel Lalin on 15/12/2023.
//

import Foundation

final class TaskDatabase {
    var tasks: [Task]
    
    init(tasks: [Task] = []) {
        self.tasks = tasks
    }
    
    func create(task: Task) -> [Task] {
        tasks.append(task)
        return tasks
    }
    
    func updateFavorite(taskId: UUID) -> [Task] {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks[index].isFavorite = !tasks[index].isFavorite
        }
        return tasks
    }
    
    
    func remove(taskId: UUID) -> [Task] {
        if let index = tasks.firstIndex(where: { $0.id == taskId }) {
            tasks.remove(at: index)
        }
        return tasks
    }
    
    func removeAll() -> [Task] {
        tasks.removeAll()
        return tasks
    } 
}
