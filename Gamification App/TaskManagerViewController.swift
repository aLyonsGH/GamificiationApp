//
//  TaskManagerViewController.swift
//  Gamification App
//
//  Created by Alex Lyons on 2/25/21.
//

import UIKit

class TaskManagerViewController: UIViewController {

    @IBOutlet weak var testTask: UIButton!
    @IBOutlet weak var timeLeft: UILabel!
    @IBOutlet weak var whenDue: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        update()
    }
    
    func update(){
        let t = TaskManager.getTaskManager().getTasks()
        if t.count == 1{
            testTask.setTitle(t[0].label, for: .normal)
            timeLeft.text = t[0].showTimeLeft(due: t[0].dateDue)
            whenDue.text = t[0].dateFormatter.string(from: t[0].dateDue)
        }
        print("updated")
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    @IBAction func AddTaskButton(_ sender: Any) {
        
        print("button transition")
        performSegue(withIdentifier: "AddTaskSegue", sender: self)
        
        
    }
    
}
