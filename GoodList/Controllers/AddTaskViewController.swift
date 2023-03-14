//
//  AddTaskViewController.swift
//  GoodList
//
//  Created by Òscar Muntal on 14/3/23.
//

import Foundation
import UIKit
import RxSwift

class AddTaskViewController: UIViewController {
    private let taskSubject = PublishSubject<Task>()
    public var taskSubjectObservable: Observable<Task> {
        return taskSubject.asObservable()
    }
    
    @IBOutlet weak var prioritySegmentedControl: UISegmentedControl!
    @IBOutlet weak var taskTitleTextField: UITextField!
    
    @IBAction func save() {
        guard let priority = Priority(rawValue: prioritySegmentedControl.selectedSegmentIndex),
              let title = taskTitleTextField.text else { return }
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        dismiss(animated: true, completion: nil)
    }
}
