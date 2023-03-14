//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Òscar Muntal on 14/3/23.
//

import UIKit
import RxSwift
import RxCocoa

class TaskListViewController: UIViewController {
    let disposeBag = DisposeBag()
    private var tasks = BehaviorRelay<[Task]>(value: [])
    private var filteredTasks = [Task]()
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.navigationBar.prefersLargeTitles = true
    }
    
}

extension TaskListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.value.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let addTaskVC = navigationController.viewControllers.first as? AddTaskViewController else { fatalError("Controller not found...") }
        
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { [unowned self] task in
                let priority = Priority(rawValue: self.prioritySegmentedControl.selectedSegmentIndex - 1)
                var existingTasks = self.tasks.value
                existingTasks.append(task)
                self.tasks.accept(existingTasks)
                self.filterTasks(by: priority)
            }).disposed(by: disposeBag)
    }
    
    private func filterTasks(by priority: Priority?) {
        // Case: All
        if priority == nil {
            self.filteredTasks = self.tasks.value
        } else {
            // Cases: High, Medium and Low
            self.tasks.map { tasks in
                tasks.filter { $0.priority == priority! }
            }.subscribe(onNext:{ [weak self] tasks in
                self?.filteredTasks = tasks
                print(tasks)
            }).disposed(by: disposeBag)
        }
    }
}
