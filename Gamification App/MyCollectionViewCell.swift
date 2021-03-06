//
//  MyCollectionViewCell.swift
//  collection-view-example
//
//  Created by loaner on 3/3/21.
//

import UIKit

class MyCollectionViewCell: UICollectionViewCell {
    
    var index: Int = -1;
    var controller: UICollectionViewControllerTest!

    @IBOutlet weak var dueDate: UILabel!
    
    @IBOutlet weak var timeLeft: UILabel!
  
    @IBOutlet weak var taskButton: UIButton!
    
    @IBAction func tempDelete(_ sender: Any) {
        print("trash")
        //TaskManager.getTaskManager().deleteTask(toRemove: index);
        TaskManager.getTaskManager().deleteTaskFromCore(taskIndex: index);
        controller.removeCell(toRemovePath: index)
        
    }
    
    @IBAction func completeTask(_ sender: Any) {
        TaskManager.getTaskManager().deleteTaskFromCore(taskIndex: index);
        controller.removeCell(toRemovePath: index)
        TaskManager.getTaskManager().completeTask()
        
        self.controller.loadGoodJobScreen()
        
    }
    
}
