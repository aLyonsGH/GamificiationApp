

import UIKit
import CoreData
import Alamofire
class UICollectionViewControllerTest: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var tasksToDisplay: [String] = []
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!

    @IBOutlet weak var collectionView: UICollectionView!
    
    struct eventsData: Decodable{
        var event: [eventInfo]?
        var total: Int?
        var links: [String:String]?
        
    }
    
    struct eventInfo: Decodable{
        var id: Int?
        var title: String?
        var description: String?
        var start: String?
        var has_end: Int?
        var end: String?
        var all_day: Int?
        var editable: Int?
        var rsvp: Int?
        var comments_enabled: Int?
        var type: String?
        var realm: String?
        var section_id: Int?
        var links: [String: String]?
    }
    
    @IBAction func testButtonInfo(_ sender: Any) {
        /*print("Number of tasks when button clicked: \(TaskManager.getTaskManager().getTasks().count)")
        
        var managedContext = TaskManager.getTaskManager().container.viewContext;
        var req: NSFetchRequest<TaskData> = TaskData.fetchRequest();
        var results : [TaskData]
         do {
             results = try managedContext.fetch(req)
         } catch {results =  [TaskData]();}
        print("Number of saved tasks when button clicked: \(results.count)")
        */
    
        let timestamp = Int(NSDate().timeIntervalSince1970)

        var uuid: CFUUID = CFUUIDCreate(nil)
        var nonce: CFString = CFUUIDCreateString(nil, uuid)
        let headers: HTTPHeaders = [
            "Authorization": "OAuth realm=Schoology API,oauth_consumer_key=1da7b3464ed37bd3983c0f3105082f380607ede7a,oauth_token=,oauth_nonce=\(nonce),oauth_timestamp=\(timestamp),oauth_signature_method=PLAINTEXT,oauth_version=1.0,oauth_signature=0c94df9ef6b2c623b1f66823ce0b1645%26",
            "Accept": "application/json",
            "Content-Type":"application/json",
            "Host": "api.schoology.com"
        ]
        
        let user = "alyons21@cgps.org"
        let password = "exp22soaa"
        let redirector = Redirector(behavior: .doNotFollow)
        let credential = URLCredential(user: user, password: password, persistence: .forSession)
        
        
        //date format: YYYY-MM-DD
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let start_date = dateFormatter.string(from: Date())
        let end_date = dateFormatter.string(from: Date().addingTimeInterval(60 * 60 * 24 * 100))
    
        AF.request("https://classroom.cgps.org/v1/users/30896655/events?start_date=\(start_date)&end_date=\(end_date)", headers: headers).redirect(using: redirector).authenticate(with: credential).responseJSON { [self] response in
           do{
            TaskManager.getTaskManager().setTaskToEdit(toEdit: -1)
               dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
               print("hi")
                let myEvents = try! JSONDecoder().decode(eventsData.self, from: response.data!)
            for e in myEvents.event!{
                var desc: String
                if e.description! == nil{
                    desc = ""
                }else{desc = e.description!}
                /*if(e.end! == nil){
                    print("date nil")
                }
                else{
                    print("date:")
                    print(e.end!)
                    print("test1")
                    print(dateFormatter.date(from: e.end!))
                    print("test2")
                    print(dateFormatter.date(from: e.end!)!)
                    print("test3")
                }*/
                if(taskNotAlreadyAdded(e: e))
                {
                    TaskManager.getTaskManager().createTask(label: e.title!, completed: true, description: desc, taskImages: [UIImage(systemName: "photo")!,UIImage(systemName: "photo")!,UIImage(systemName: "photo")!], dateDue: dateFormatter.date(from: e.start!)!, taskType: Task.TYPE.school)
                }
                
            }
            
            viewWillAppear(false);
        
            }catch{print("failed")}
           
            
        }
        
    }
    
    func taskNotAlreadyAdded(e: eventInfo) -> Bool{
        for t in TaskManager.getTaskManager().getTasks(){
            if(t.label==e.title){
                return false
            }
        }
        return true
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        //print("cells being formatted")
        return self.tasksToDisplay.count
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        print("edit segue");
        let pos = indexPath.row;
        TaskManager.getTaskManager().setTaskToEdit(toEdit: pos);
        performSegue(withIdentifier: "EditTaskSegue", sender: self)

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
        TaskManager.getTaskManager().setTasks();
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddTaskSegue"{
            let destination = segue.destination as! AddTaskViewController;
            destination.inputType = "Adding"
        }
    }
    
    
   

}

