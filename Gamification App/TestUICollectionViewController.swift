//
//  ViewController.swift
//  collection-view-example
//
//  Created by loaner on 3/3/21.
//

import UIKit

class TestUICollectionViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    var pokedex: ["test 1", "test 2", "test 3"]
    var screenSize: CGRect!
    var screenWidth: CGFloat!
    var screenHeight: CGFloat!
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.pokedex.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath as IndexPath) as! MyCollectionViewCell
        
        cell.myLabel.text = self.pokedex[indexPath.row].name // The row value is the same as the index of the desired text within the array.
        cell.backgroundColor = UIColor.cyan // make cell more visible in our example project
        
        cell.frame.size.width = screenWidth
        cell.frame.size.height = screenWidth/2
    
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return screenWidth/2 + 50.0;
        } //space between rows

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 1000;
        } //space between items in same row
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            
        return CGSize(width: screenWidth, height: 10.0);
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        print ("You selected #\(indexPath.item)!")
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        //var collectionViewFlowLayout = UICollectionViewFlowLayout()
        //var myCollectionView = UICollectionView(frame: self.view.bounds, collectionViewLayout: collectionViewFlowLayout)
        screenSize = UIScreen.main.bounds
        screenWidth = screenSize.width
        screenHeight = screenSize.height
        
        // Do any additional setup after loading the view.
    }


}

