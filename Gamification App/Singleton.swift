import UIKit
import CoreData

class TaskManager {

    private static var tasks = [Task]()
    private static var taskManager: TaskManager? = nil
    private var taskToEditIndex: Int = -1;
    
    static var setTasksFromData = false;
    
    var container: NSPersistentContainer;
    
    var testImages: [UIImage] = [UIImage(systemName: "photo")!,UIImage(systemName: "photo")!]

    private init(tasks: [Task]) {
        
        TaskManager.tasks = tasks
        container = NSPersistentContainer(name: "TaskDataModel")
        container.loadPersistentStores {storeDescription, error in if let error = error{
            print("Unresolved error \(error)")
            //storeDescription, error
            }
        }
        
        
        //REMOVE TO STOP DELETING ALL DATA
        //deleteAllData(entity: "TaskData");
        //deleteAllData(entity: "CompletionData");
    }


        static func getTaskManager() -> TaskManager {
        if TaskManager.taskManager == nil{
            TaskManager.taskManager = TaskManager(tasks: tasks)
        }
        return TaskManager.taskManager!
    }
    
    
    //Crud Methods:
    
    //create
    func createTask(label: String,completed: Bool,description: String,taskImages: [UIImage], dateDue: Date,taskType: Task.TYPE){
        save(task: Task(label: label,completed: completed,description: description,taskImages: taskImages, dateDue: dateDue,taskType: taskType))
    }
    
    func createTask(label: String,completed: Bool,description: String,taskImages: [UIImage], dateDue: Date,taskType: Task.TYPE, saveToCoreData: Bool){
        if saveToCoreData{
            save(task: Task(label: label,completed: completed,description: description,taskImages: taskImages, dateDue: dateDue,taskType: taskType))
        }else{
            TaskManager.tasks.append(Task(label: label,completed: completed,description: description,taskImages: taskImages, dateDue: dateDue,taskType: taskType));
        }
    }
    
    func replaceTask(label: String,completed: Bool,description: String,taskImages: [UIImage], dateDue: Date,taskType: Task.TYPE){
        let managedContext = container.viewContext;
        let req: NSFetchRequest<TaskData> = TaskData.fetchRequest()
        var results : [TaskData]

         do {
             results = try managedContext.fetch(req)
            let ind: Int = getTaskToEditIndex();
            results[ind].setValue(label, forKeyPath: "labelData");
            results[ind].setValue(description, forKeyPath: "descriptionData")
            results[ind].setValue(dateDue, forKeyPath: "dueDateData")
            results[ind].setValue(taskImages[0].pngData(), forKeyPath: "firstImageData")
            results[ind].setValue(taskImages[1].pngData(), forKeyPath: "secondImageData")
            results[ind].setValue(taskImages[2].pngData(), forKeyPath: "thirdImageData")
            results[ind].setValue(Task.getStringType(type: taskType), forKeyPath: "taskTypeData")
            try managedContext.save()
            TaskManager.tasks[ind].label = label;
            TaskManager.tasks[ind].description = description;
            TaskManager.tasks[ind].dateDue = dateDue;
            TaskManager.tasks[ind].taskImages = taskImages;
            TaskManager.tasks[ind].taskType = taskType;
            TaskManager.tasks[ind].completed = completed;
         } catch {results =  [TaskData](); print("error updating core data edits");}
        
        
    }
    
    //read
    func getTasks() -> [Task]{
        return TaskManager.tasks;
    }
    
    func setTasks(){
        //Fetch data from core data
        //Convert between NSObjects and task objects
        
        print(" ");
        print(TaskManager.getTaskManager().getTasks().count);
        
        let managedContext = container.viewContext;
        let req: NSFetchRequest<TaskData> = TaskData.fetchRequest()
        var results : [TaskData]

         do {
             results = try managedContext.fetch(req)
         } catch {results =  [TaskData](); print("error loading results");}
        
        /*[UIImage(data: t.firstImageData), t.secondImageData, t.thirdImageData]*/
        
        if TaskManager.getTaskManager().getTasks().count>0
        {
            print(TaskManager.getTaskManager().getTasks()[0].label);
        }
        TaskManager.tasks = [Task]();
        print("Length of results: \(results.count)")
        for t in results{
            print(t.labelData);
            if !(t.dueDateData==nil){
                print("creating task");
                TaskManager.getTaskManager().createTask(label: t.labelData!, completed: true, description: t.descriptionData!, taskImages: [UIImage(data: t.firstImageData!)!,UIImage(data: t.secondImageData!)!,UIImage(data: t.thirdImageData!)!], dateDue: t.dueDateData!, taskType: Task.getTypeString(typeString: t.taskTypeData!), saveToCoreData: false)
            }
        }
        
        print(TaskManager.getTaskManager().getTasks().count);
        
        print("setting tasks");
        
        /*let managedContext = container.viewContext;

          let fetchRequest =
            NSFetchRequest<NSManagedObject>(entityName: "TaskData")
          
          //3
          do { //here is where convert data
            let fetchedData = try managedContext.fetch(fetchRequest)
            print(fetchedData.);
            //TaskManager.tasks
          } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
          }*/
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
        return TaskManager.getTaskManager().getTasks()[taskToEditIndex]
    }
    
    func setTaskToEdit(toEdit: Int){
        taskToEditIndex = toEdit;
    }
    
    func getTaskToEditIndex()->Int{
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
    
    func updateTaskImages(taskImages: [UIImage], task: Task){
        for t in TaskManager.tasks {
            if t === task{
                for i in 0...t.taskImages.count-1
                {
                    t.taskImages[i] = taskImages[i]
                }
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
        taskObject.setValue(task.dateDue, forKeyPath: "dueDateData");
        taskObject.setValue(task.taskImages[0].pngData(), forKeyPath: "firstImageData");
        taskObject.setValue(task.taskImages[1].pngData(), forKeyPath: "secondImageData");
        taskObject.setValue(task.taskImages[2].pngData(), forKeyPath: "thirdImageData");
        taskObject.setValue(Task.getStringType(type: task.taskType), forKeyPath: "taskTypeData");
        
        print("Length of tasks BEFORE adding a new task to save: \(TaskManager.tasks.count)");
        
        do {
            try managedContext.save()
            TaskManager.tasks.append(task)
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
        
        print("Length of tasks AFTER adding a new task to save: \(TaskManager.tasks.count)")
        }
    
    func deleteAllData(entity: String)
    {
        let managedContext = container.viewContext;
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entity);
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            let results = try managedContext.fetch(fetchRequest)
            for managedObject in results
            {
                let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                managedContext.delete(managedObjectData)
            }
        } catch let error as NSError {
            print("Detele all data in \(entity) error : \(error) \(error.userInfo)")
        }
        
        do{try managedContext.save();}
        catch{}
    }
    
    func deleteTaskFromCore(taskIndex: Int)
    {
        print("Length of tasks BEFORE deleting item: \(TaskManager.tasks.count)")
        let managedContext = container.viewContext;
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "TaskData");
        fetchRequest.returnsObjectsAsFaults = false
        do
        {
            
            let results = try managedContext.fetch(fetchRequest)
            //print("Length of core tasks BEFORE deleting item: \(results.count)");
            for i in 0..<results.count {
                let managedObject = results[i];
                if i == taskIndex{
                    print("Deleting task at index: \(taskIndex)");
                    let managedObjectData:NSManagedObject = managedObject as! NSManagedObject
                    managedContext.delete(managedObjectData)
                    do{try managedContext.save();}
                    catch{}
                }
            }
            //print("Length of core tasks AFTER deleting item: \(results.count)");
        } catch let error as NSError {
            print("Detele all data in TaskData error : \(error) \(error.userInfo)")
        }
        print("Length of tasks AFTER deleting item: \(TaskManager.tasks.count)")
    }
    
    func completeTask()
    {
        let managedContext = TaskManager.getTaskManager().container.viewContext;
        let req: NSFetchRequest<CompletionData> = CompletionData.fetchRequest();
        var results : [CompletionData]
         do {
             results = try managedContext.fetch(req)
            if results.count == 0
            {
                setupCompletionData()
                completeTask()
            }
            else
            {
                results[0].setValue(results[0].tasksCompletedData+1, forKey: "tasksCompletedData")
                print("\(results[0].tasksCompletedData) tasks completed")
            }
         } catch {results =  [CompletionData]();}
        
    }
    
    func setupCompletionData()
    {
        let managedContext = container.viewContext;
        let entity = NSEntityDescription.entity(forEntityName: "CompletionData", in: managedContext)!
        
        let taskObject = NSManagedObject(entity: entity, insertInto: managedContext);
        taskObject.setValue(0, forKeyPath: "tasksCompletedData");
    
        do {
            try managedContext.save()
            
          } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
          }
    }
    
    

}
