//
//  ViewController.swift
//  rxGoodList
//
//  Created by Jad Messadi on 11/13/20.
//

import UIKit
import RxSwift
import RxCocoa

class GoodsListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
  
    @IBOutlet weak var prioritySegmentedBar : UISegmentedControl!
    @IBOutlet weak var tableView : UITableView!
    let tasks = BehaviorRelay<[Task]>(value: [])
    var filtredTask = [Task]()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        self.filtredTask.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell  = tableView.dequeueReusableCell(withIdentifier: "goodCellId", for: indexPath)
        cell.textLabel?.text = self.filtredTask[indexPath.row].title
        return cell
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        guard let navC = segue.destination as? UINavigationController,
              let addGVC = navC.viewControllers.first as? AddGoodViewController else {
            fatalError("error")
        }
        addGVC.taskSubjectObservable.subscribe(onNext: { task in
            let priority = Priority(rawValue: self.prioritySegmentedBar.selectedSegmentIndex - 1)
            var allTasks = self.tasks.value
            allTasks.append(task)
            self.tasks.accept(allTasks)
            self.filterList(by: priority)
        }).disposed(by: disposeBag)
        
    }
    
    @IBAction func priorityValueChanged(segmentedControl: UISegmentedControl) {
    
        let priority = Priority(rawValue: self.prioritySegmentedBar.selectedSegmentIndex - 1)
        filterList(by: priority)
    }
    
    
    private func filterList(by priority : Priority?) {
        
        if priority == nil {
            self.filtredTask = self.tasks.value
            self.updateGoodsList()
        }else {
            self.tasks.map { task in
                return task.filter{
                    $0.priority == priority
                }
            }.subscribe(onNext: { task in
                self.filtredTask = task
                self.updateGoodsList()

            }).disposed(by: disposeBag)
                
            
        }
    }
    
    private func updateGoodsList() {
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
}

