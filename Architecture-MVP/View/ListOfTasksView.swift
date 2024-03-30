//
//  ViewController.swift
//  Architecture-MVP
//
//  Created by Nahuel Lalin on 15/12/2023.
//

import UIKit

class ListOfTasksView: UIViewController {
    var presenter = TaskPresenter()
    
    private let taskTextView: UITextView = {
        let textView = UITextView()
        textView.font = UIFont.systemFont(ofSize: 18, weight: .regular)
        textView.backgroundColor = .systemGray6
        textView.textColor = .label
        textView.layer.cornerRadius = 12
        textView.layer.borderColor = UIColor.systemGray3.cgColor
        textView.layer.borderWidth = 1
        textView.textContainerInset = UIEdgeInsets(top: 10, left: 8, bottom: 10, right: 8)
        textView.translatesAutoresizingMaskIntoConstraints = false
        return textView
    }()
    
    private lazy var createTaskButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Create", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        button.backgroundColor = .systemBlue
        button.layer.cornerRadius = 12
        button.clipsToBounds = true
        button.addTarget(self, action: #selector(didTapOnCreateTask), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    // List to show tasks
    private lazy var taskCollectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = .init(width: 390, height: 80)
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .systemGroupedBackground
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        // Register cell type
        collectionView.register(TaskCollectionViewCell.self, forCellWithReuseIdentifier: "TaskCollectionViewCell")
        return collectionView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let removeAllButton = UIBarButtonItem(title: "Remove All", style: .done, target: presenter, action: #selector(presenter.removeAllTasks))
        self.navigationItem.rightBarButtonItem = removeAllButton
        
        [taskTextView, createTaskButton, taskCollectionView].forEach(view.addSubview)
        
        NSLayoutConstraint.activate([
            taskTextView.topAnchor.constraint(equalTo: view.layoutMarginsGuide.topAnchor, constant: 20),
            taskTextView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor),
            taskTextView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6),
            taskTextView.heightAnchor.constraint(equalToConstant: 40),
            
            createTaskButton.topAnchor.constraint(equalTo: taskTextView.topAnchor),
            createTaskButton.leadingAnchor.constraint(equalTo: taskTextView.trailingAnchor, constant: 12),
            createTaskButton.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor),
            createTaskButton.heightAnchor.constraint(equalToConstant: 40),
            createTaskButton.widthAnchor.constraint(equalToConstant: 50),
            
            taskCollectionView.topAnchor.constraint(equalTo: taskTextView.bottomAnchor, constant: 12),
            taskCollectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            taskCollectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            taskCollectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
        
        taskCollectionView.dataSource = self
        
        // This View is the presenter's delegate
        presenter.delegate = self
    }
    
    @objc func didTapOnCreateTask() {
        presenter.create(task: taskTextView.text)
    }

}

// Add protocol to show tasks on my collectionView
extension ListOfTasksView: UICollectionViewDataSource {
    // Number of cells
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        presenter.tasks.count
    }
    
    // Visually represent each cell
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TaskCollectionViewCell", for: indexPath) as! TaskCollectionViewCell
        
        let task = presenter.tasks[indexPath.row]
        
        cell.configure(id: task.id, text: task.text, isFavorite: task.isFavorite)
        
        cell.tapOnFavorite =  { [weak self] taskId in
            self?.presenter.updateFavorite(taskId: taskId)
        }
        
        cell.tapOnRemove =  {  [weak self] taskId in
            self?.presenter.removeTask(taskId: taskId)
        }
        
        return cell
    }
}

// This ViewController conforms presenter's delegate
extension ListOfTasksView: TaskPresenterProtocol {
    func update(){
        taskTextView.text = ""
        taskCollectionView.reloadData()
    }
}

