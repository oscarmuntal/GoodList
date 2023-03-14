//
//  TaskListViewController.swift
//  GoodList
//
//  Created by Òscar Muntal on 14/3/23.
//

import UIKit
import RxSwift

class TaskListViewController: UIViewController {
    let disposeBag = DisposeBag()
    private var tasks = Variable<[Task]>([])
    
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
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskTableViewCell", for: indexPath)
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let navigationController = segue.destination as? UINavigationController,
              let addTaskVC = navigationController.viewControllers.first as? AddTaskViewController else { fatalError("Controller not found...") }
        
        addTaskVC.taskSubjectObservable
            .subscribe(onNext: { task in
                self.tasks.value.append(task)
            }).disposed(by: disposeBag)
    }
}
