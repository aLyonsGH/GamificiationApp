import UIKit
import RealityKit
import Foundation

class NewARViewController: UIViewController {
    
    @IBOutlet var ARView: ARView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        let boxAnchor = try! Experience.loadBox()
        
        // Add the box anchor to the scene
        ARView.scene.anchors.append(boxAnchor)
        
        do{
            print("check 1")
            /*let modelScene =  try? Entity.loadModel(named: "GoodJobScene.reality")
            let modelScene2 =  try? Entity.loadAnchor(named: "GoodJobScene.reality")*/
            /*let url = URL(fileURLWithPath: "/Users/Alex/Downloads/main.reality")
            let entity = try? Entity.load(contentsOf: url)*/
            
            /*let fileURL = Bundle.main.url(forResource: "main", withExtension: "reality")
            let scene = try! Entity.load(contentsOf: fileURL!)*/

        }
        print("loaded")
        
    }
    
    
}
