//
//  TaskPresenter.swift
//  Architecture-MVP
//
//  Created by Nahuel Lalin on 23/12/2023.
//

import Foundation

protocol TaskPresenterProtocol: AnyObject {
    func update()
}

final class TaskPresenter {
    
    weak var delegate: TaskPresenterProtocol?
    
    var tasks: [Task] = []
    
    private var taskDataBase = TaskDatabase()
    
    func create(task: String) {
        guard !task.isEmpty else {
            return
        }
        let newTask: Task = .init(text: task, isFavorite: false)
        tasks = taskDataBase.create(task: newTask)
        
        // Call update function from protocol
        delegate?.update()
    }
    
    func updateFavorite(taskId: UUID) {
        tasks = taskDataBase.updateFavorite(taskId: taskId)
        delegate?.update()
    }
    
    func removeTask(taskId: UUID) {
        tasks = taskDataBase.remove(taskId: taskId)
        delegate?.update()
    }
    
    @objc func removeAllTasks() {
        tasks = taskDataBase.removeAll()
        delegate?.update()
    }
}
