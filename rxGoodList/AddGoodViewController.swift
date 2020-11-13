//
//  AddGoodViewController.swift
//  rxGoodList
//
//  Created by Jad Messadi on 11/13/20.
//

import UIKit
import RxSwift

class AddGoodViewController: UIViewController {

    @IBOutlet weak var prioritySegmentedBar : UISegmentedControl!
    @IBOutlet weak var addGoodTextField : UITextField!
    private let taskSubject = PublishSubject<Task>()
    
    var taskSubjectObservable : Observable<Task> {
        return taskSubject.asObservable()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveGood () {
        guard let priority = Priority(rawValue: self.prioritySegmentedBar.selectedSegmentIndex), let title = addGoodTextField.text else { return }            
        let task = Task(title: title, priority: priority)
        taskSubject.onNext(task)
        self.dismiss(animated: true, completion: nil)
        
    }


}
