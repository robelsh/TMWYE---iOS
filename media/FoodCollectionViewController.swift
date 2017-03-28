//
//  FoodCollectionViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 10/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase
import SwiftSpinner

private let reuseIdentifier = "Cell"
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class FoodCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let itemsPerRow: CGFloat = 3

    var ref: FIRDatabaseReference!
    var foods:[String] = []
    var foodImgs:[UIImage] = []
    var foodIds:[NSNumber] = []
    var name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Foods, please wait...")
        self.ref = FIRDatabase.database().reference()
        ref.child("food").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let childItem = child.value as! Dictionary<String,Any>
                
                if let name = childItem["name"] as? String {
                    self.foodImgs.append(UIImage(named: name)!)
                    self.name = name
                }
                
                self.foods.append(self.name)
                
                
                if let id = childItem["id"] as? NSNumber {
                    self.foodIds.append(id)
                }
            }
            self.collectionView?.reloadData()
            SwiftSpinner.hide()
        })
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.foods.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FoodCollectionViewCell {
        let cell:FoodCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodcell", for: indexPath) as! FoodCollectionViewCell
        cell.display(title: self.foods[indexPath.row], img: self.foodImgs[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = view.frame.width - paddingSpace
        let widthPerItem = availableWidth / itemsPerRow
        
        return CGSize(width: widthPerItem, height: widthPerItem)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showFood" {
            let list = segue.destination as! FoodTableViewController
            let cell = sender as! FoodCollectionViewCell
            let indexPaths = self.collectionView?.indexPath(for: cell)
            list.titleView = foods[(indexPaths?.row)!]
            list.catId = foodIds[(indexPaths?.row)!]
        }
    }
}
