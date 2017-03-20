//
//  VotesCollectionViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 20/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class VotesCollectionViewController: UICollectionViewController {
    var categories:[String] = []
    var categoriesId:[NSNumber] = []
    var ref: FIRDatabaseReference!
    var imdbId = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        ref.child("food").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let childItem = child.value as! Dictionary<String,Any>
                if let name = childItem["name"] as? String {
                    self.categories.append(name)
                    
                }
                if let id = childItem["id"] as? NSNumber {
                    self.categoriesId.append(id)
                }
            }
            for catID in self.categoriesId {
                var count = 0
                var oldCat = NSNumber()
                oldCat = 0
                
                let mRef = self.ref.child("medias/\(self.imdbId)").queryOrderedByValue().queryEqual(toValue: catID)
                mRef.observe(.childAdded, with: { (snapshot) -> Void in
                    count = count + 1
                    oldCat = snapshot.value as! NSNumber
                    self.collectionView?.reloadData()
                })
                
                self.ref.child("medias/\(self.imdbId)").observe(.childChanged, with: { (snapshot) -> Void in
                    if oldCat == catID {
                        count = count - 1
                        oldCat = snapshot.value as! NSNumber
                    }
                    self.collectionView?.reloadData()
                })
            }
            self.collectionView?.reloadData()
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
        return self.categories.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> VoteCollectionViewCell {
        let cell:VoteCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "voteCell", for: indexPath) as! VoteCollectionViewCell
        cell.display(name: self.categories[indexPath.row], img: UIImage(named: self.categories[indexPath.row])!)
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let uid:String = (FIRAuth.auth()?.currentUser?.uid)! as String
        
        let childUpdates = ["imdbID": self.imdbId, uid: self.categoriesId[indexPath.row]] as [String : Any]
        
        ref.child("medias/\(self.imdbId)").updateChildValues(childUpdates)
    }
}
