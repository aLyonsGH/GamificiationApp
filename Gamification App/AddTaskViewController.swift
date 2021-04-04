//
//  AddTaskViewController.swift
//  Gamification App
//
//  Created by Alex Lyons on 2/18/21.
//

import UIKit

class AddTaskViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate{
    
    var imagePicker = UIImagePickerController();
    var inputType: String?

    @IBAction func addImg(_ sender: Any) {
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){

                    imagePicker.sourceType = .savedPhotosAlbum
                    imagePicker.allowsEditing = false
                
                    present(imagePicker, animated: true, completion: nil)
        }
    }
    
    func displayImages(pickedImage: UIImage)
    {
        for n in 0...visibleImages.count-2 {
            self.visibleImages[visibleImages.count-1-n].image = self.visibleImages[visibleImages.count-1-n-1].image
        }
        
        self.visibleImages[0].contentMode = .scaleAspectFit
        self.visibleImages[0].image = pickedImage
    }

        
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            displayImages(pickedImage: pickedImage)
        }
        dismiss(animated: true, completion: nil)

        }
        
    @IBOutlet var visibleImages: Array<UIImageView>!

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


    
    @IBOutlet weak var addTaskButtonLabel: UIButton!
    @IBOutlet weak var labelInput: UITextView!
    @IBOutlet weak var descriptionInput: UITextView!
    @IBOutlet weak var typeInput: UIPickerView!
    @IBOutlet weak var dateInput: UIDatePicker!
    @IBAction func AddTaskButton(_ sender: UIButton) {
        print(TaskManager.getTaskManager().getTaskToEditIndex())
        if(TaskManager.getTaskManager().getTaskToEditIndex()==(-1))
        {
            TaskManager.getTaskManager().createTask(label: labelInput.text!, completed: true, description: descriptionInput.text!, taskImages: getImagesFromDisplay(), dateDue: dateInput.date, taskType: TaskManager.getTaskType(taskType: currentPickerVal))
        }
        else
        {
            TaskManager.getTaskManager().replaceTask(label: labelInput.text!, completed: true, description: descriptionInput.text!, taskImages: getImagesFromDisplay(), dateDue: dateInput.date, taskType: TaskManager.getTaskType(taskType: currentPickerVal))
        }
        print("new task created")
        print(TaskManager.getTaskManager().getTasks().count)
        TaskManager.getTaskManager().setTaskToEdit(toEdit: -1);
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("add task loaded")
        typeInput.dataSource = self
        typeInput.delegate = self
        imagePicker.delegate = self
    }
    
    func getImagesFromDisplay() -> [UIImage]
    {
        /*print("all images not the same:")
        print(visibleImages[0].image! != visibleImages[1].image! ||
                visibleImages[0].image! != visibleImages[2].image! ||
              visibleImages[1].image! != visibleImages[2].image!)*/
        return [visibleImages[0].image!, visibleImages[1].image!, visibleImages[2].image!]
    }
    
    func editSetup(){
        if TaskManager.getTaskManager().getTaskToEditIndex() == -1{
            addTaskButtonLabel.setTitle("Add Task", for: .normal)
            print("not editing");
        }
        else{
            print("editing");
            addTaskButtonLabel.setTitle("Edit Task", for: .normal)
            let t = TaskManager.getTaskManager().loadTaskToEdit();
            labelInput.text = t?.label;
            descriptionInput.text = t?.description;
            dateInput.date = t!.dateDue;
            
            for i in 0...t!.taskImages.count-1
            {
                displayImages(pickedImage: (t?.taskImages[t!.taskImages.count-1-i])!)
            }
            
            
            //TaskManager.getTaskManager().setTaskToEdit(toEdit: -1);
        }
    
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        editSetup();
        
    }
    
   
   
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
    }
    

}
