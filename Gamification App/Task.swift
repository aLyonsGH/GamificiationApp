import UIKit
class Task {
    var label: String
    var completed: Bool
    var description: String
    var taskImg: UIImage
    var dateDue: Date
    let dateCreated: Date = Date()
    enum TYPE {
        case hobby, school, other
    }
    var taskType: TYPE
    let dateFormatter = DateFormatter()
    
    init(label: String,completed: Bool,description: String,taskImg: UIImage, dateDue: Date, taskType: TYPE) {
        self.label = label
        self.completed = completed
        self.description = description
        self.taskImg = taskImg
        self.taskType = taskType
        self.dateDue = dateDue
        dateFormatter.dateFormat = "MM-dd-yyyy HH:mm"
    }
    
    func computeTimeLeft(due: Date) -> Int {
        return Int(Date().distance(to: due))
    }
    
    func convertStringtoDate(stringDate: String) -> Date {
        return dateFormatter.date(from: stringDate)!
    }
    
    func showTimeLeft(due: Date) -> String {
        //86400 seconds in a day
        //3600 seconds in an hour
        //60 seconds in a minute
        let seconds = computeTimeLeft(due: due)
        //print(seconds)
        return "Days: \(seconds/86400)\nHours: \((seconds%86400)/3600)\nMinutes: \(((seconds%86400)%3600)/60)\nSeconds: \(((seconds%86400)%3600)%60)"
    }
}


