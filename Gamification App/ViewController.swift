import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var testButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        testButton.backgroundColor = UIColor.gray
        // Do any additional setup after loading the view.
    }

    @IBAction func buttonClicked(_ sender: Any) {
        var testTask = Task(label: "TestTask",completed: false,description: "This is a test task", taskImg: UIImage(named: "testImage.jpeg")!,dateDue: Date(), taskType: Task.TYPE.hobby)
        testButton.backgroundColor = UIColor.red
        let testDue: Date = testTask.convertStringtoDate(stringDate: "02-18-2021 21:00")
        let testReturn: String = testTask.showTimeLeft(due: testDue)
        testButton.setTitle(testReturn, for: .normal)
    }
}






