//
//  AddTaskViewController.swift
//  Gamification App
//
//  Created by Alex Lyons on 2/18/21.
//

import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var imagePicker = UIImagePickerController();

    @IBAction func addImg(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
                    print("Button capture")

                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                     print("Yo4")
                    present(imagePicker, animated: true, completion: nil)
        }
    }

        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                    self.visibleImage.contentMode = .scaleAspectFit
                self.visibleImage.image = pickedImage
        }
        dismiss(animated: true, completion: nil)

        }
        
    
    @IBOutlet weak var visibleImage: UIImageView!
    
    let pickerData = ["Hobby", "School", "Other"]
    var currentPickerVal = ""
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        currentPickerVal = pickerData[row]
        return pickerData[row]
    }


    
    override func didReceiveMemoryWarning() {
            super.didReceiveMemoryWarning()
  
        }


    
    @IBOutlet weak var labelInput: UITextView!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var typeInput: UIPickerView!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBAction func AddTaskButton(_ sender: UIButton) {
        TaskManager.getTaskManager().createTask(label: labelInput.text!, completed: true, description: descriptionInput.text!, taskImg: #imageLiteral(resourceName: "testImage.jpeg"), dateDue: dateInput.date, taskType: TaskManager.getTaskType(taskType: currentPickerVal))
        print("new task created")
        print(TaskManager.getTaskManager().getTasks().count)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("add task loaded")
        typeInput.dataSource = self
        typeInput.delegate = self
        imagePicker.delegate = self
    }
    
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}
