import UIKit

class TaskManager {

    private static var tasks = [Task]()
    private static var taskManager: TaskManager? = nil

    private init(tasks: [Task]) {
        TaskManager.tasks = tasks
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
        TaskManager.tasks.append(Task(label: label,completed: completed,description: description,taskImg: taskImg, dateDue: dateDue,taskType: taskType))
    }
    
    //read
    func getTasks() -> [Task]{
        return TaskManager.tasks
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
    


}
