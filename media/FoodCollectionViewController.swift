//
//  FoodCollectionViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 10/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

private let reuseIdentifier = "Cell"
fileprivate let sectionInsets = UIEdgeInsets(top: 50.0, left: 20.0, bottom: 50.0, right: 20.0)

class FoodCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {

    fileprivate let itemsPerRow: CGFloat = 3

    var testImg:[UIImage] = []
    let test = ["Sandwitch","Hamburger","Noodle", "Pizza", "Sushi", "Salad"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        testImg.append(UIImage(named: "sandwitch")!)
        testImg.append(UIImage(named: "hamburger")!)
        testImg.append(UIImage(named: "noodle")!)
        testImg.append(UIImage(named: "pizza")!)
        testImg.append(UIImage(named: "sushi")!)
        testImg.append(UIImage(named: "salad")!)

        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.test.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> FoodCollectionViewCell {
        let cell:FoodCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "foodcell", for: indexPath) as! FoodCollectionViewCell
        cell.display(title: self.test[indexPath.row], img: self.testImg[indexPath.row])
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
}
