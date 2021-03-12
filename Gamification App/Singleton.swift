import UIKit
import CoreData

class TaskManager {

    private static var tasks = [Task]()
    private static var taskManager: TaskManager? = nil
    private var taskToEditIndex: Int? = -1;
    var container: NSPersistentContainer;

    private init(tasks: [Task]) {
        TaskManager.tasks = tasks
        container = NSPersistentContainer(name: "TaskDataModel")
        container.loadPersistentStores {storeDescription, error in if let error = error{
            print("Unresolved error \(error)")
            //storeDescription, error
        }
        }
    }


        static func getTaskManager() -> TaskManager {
        if TaskManager.taskManager == nil{
            TaskManager.taskManager = TaskManager(tasks: tasks)
        }
        return TaskManager.taskManager!
    }
    
    
    //Crud Methods:
    
    //create
    func createTask(label: String,completed: Bool,description: String,taskImg: UIImage, dateDue: Date,taskType: Task.TYPE){
        save(task: Task(label: label,completed: completed,description: description,taskImg: taskImg, dateDue: dateDue,taskType: taskType))
    }
    
    //read
    func getTasks() -> [Task]{
        //Fetch data from core data
        //Convert between NSObjects and task objects
        
        let managedContext = container.viewContext;

          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TaskData")
          
          //3
          do { //here is where convert data
            TaskManager.getTaskManager().getTasks() = try managedContext.fetch(fetchRequest)
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }
        
        return TaskManager.tasks;
    }
    
    func getTask(label: String) -> Task?{
        for task in TaskManager.tasks {
            if task.label == label{
                return task
            }
        }
        return nil
    }
    
        static func getTaskType(taskType: String) -> Task.TYPE{
        if taskType == "School"{
            return Task.TYPE.school
        }
        else if taskType == "Hobby"{
            return Task.TYPE.hobby
        }
        else if taskType == "Other"{
            return Task.TYPE.other
        }
        return Task.TYPE.other
    }
    
    func loadTaskToEdit() ->Task?{
        return TaskManager.getTaskManager().getTasks()[taskToEditIndex!]
    }
    
    func setTaskToEdit(toEdit: Int?){
        taskToEditIndex = toEdit;
    }
    
    func getTaskToEditIndex()->Int?{
        return taskToEditIndex;
    }
    
    //update
    func updateTaskLabel(label: String, task: Task){
        for t in TaskManager.tasks {
            if t === task{
                t.label = label
            }
        }
    }
    
    func updateTaskDescription(description: String, task: Task){
        for t in TaskManager.tasks {
            if t === task{
                t.description = description
            }
        }
    }
    
    func updateTaskDueDate(dueDate: Date, task: Task){
        for t in TaskManager.tasks {
            if t === task{
                t.dateDue = dueDate
            }
        }
    }
    
    func updateTaskImage(taskImg: UIImage, task: Task){
        for t in TaskManager.tasks {
            if t === task{
                t.taskImg = taskImg
            }
        }
    }


    func updateTaskType(taskType: Task.TYPE, task: Task){
        for t in TaskManager.tasks {
            if t === task{
                t.taskType = taskType
            } 
        }
    }
    
    //destroy
    
    func updateTaskImage(toRemove: Task){
        for i in 0...TaskManager.tasks.count-1{
            if TaskManager.tasks[i] === toRemove{
                TaskManager.tasks.remove(at: i)
            }
        }
    }
    
    func deleteTask(toRemove: Int){
        TaskManager.tasks.remove(at: toRemove)
    }
    
    //data model stuff
    func save(task: Task){
        let managedContext = container.viewContext;
        let entity = NSEntityDescription.entity(forEntityName: "TaskData", in: managedContext)!
        let taskObject = NSManagedObject(entity: entity, insertInto: managedContext);
        taskObject.setValue(task.label, forKeyPath: "labelData");
        taskObject.setValue(task.description, forKeyPath: "descriptionData");
        
        do {
            try managedContext.save()
            TaskManager.tasks.append(task)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
        }
    
    

}
