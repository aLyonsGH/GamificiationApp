

import UIKit
class UICollectionViewControllerTest: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var tasksToDisplay: [String] = []
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    @IBOutlet weak var collectionView: UICollectionView!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("cells being formatted")
        return self.tasksToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        print("making cell")
        cell.controller = self;
        cell.index = indexPath.row;
        
        
        
        
        /*if cell.shouldDelete() == true{
            TaskManager.getTaskManager().deleteTask(toRemove: indexPath.row)
            tasksToDisplay.remove(at: indexPath.row);
            update();
            print("found a cell to delete");
        }*/

        
        //cell.dueDate.text = self.tasksToDisplay[indexPath.row]// The row value is the same as the index of the desired text within the array.
        //cell.timeLeft.text = self.tasksToDisplay[indexPath.row]
        //print("cell started being made")
        //print(indexPath.row)
        //print(TaskManager.getTaskManager().getTasks().count)
        if indexPath.row<TaskManager.getTaskManager().getTasks().count{
            //print("adding item")
            cell.taskButton.setTitle(TaskManager.getTaskManager().getTasks()[indexPath.row].label, for: .normal)
            cell.dueDate.text = TaskManager.getTaskManager().getTasks()[indexPath.row].showTimeLeft(due: TaskManager.getTaskManager().getTasks()[indexPath.row].dateDue)// The row value is the same as the index of the desired text within the array.
            cell.timeLeft.text = TaskManager.getTaskManager().getTasks()[indexPath.row].dateFormatter.string(from: TaskManager.getTaskManager().getTasks()[indexPath.row].dateDue)
        }
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        cell.frame.size.width = screenWidth
        cell.frame.size.height = 100
    
        //print("cell made")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        //print("rows being formatted")
        return 110;
        } //space between rows

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        //print("spacings being formatted")
        return 1000;
        } //space between items in same row
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //print("sizes being formatted")
        return CGSize(width: screenWidth, height: 1.0);
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //print ("You selected #\(indexPath.item)!")
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //print("loaded")
        //tasksToDisplay.append("test 1")
    
        
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        collectionView.dataSource = self
        collectionView.delegate = self
        
        //print("loaded 2")
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //print("")
        //print("appear code")
        update();
    }
    
    func resetScreen(){
        tasksToDisplay = [];
    }
    
    func update(){
        resetScreen();
        collectionView.reloadData()
        for t in TaskManager.getTaskManager().getTasks(){
            //print("task added to tasksToDisplay")
            tasksToDisplay.append(t.label);
        }
        //print("updated")
    }
    
    func removeCell(toRemovePath: Int) {
        TaskManager.getTaskManager().deleteTask(toRemove: toRemovePath)
        update();
    }
    
    
   

}
