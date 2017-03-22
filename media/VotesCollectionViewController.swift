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
    var previousSelection = IndexPath()
    var active:[Bool] = [false]
    var counters:[Int] = []
    
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
                self.active.append(false)
                self.counters.append(0)
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
        cell.display(name: self.categories[indexPath.row], img: UIImage(named: self.categories[indexPath.row])!, active: self.active[indexPath.row], count: self.counters[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let uid:String = (FIRAuth.auth()?.currentUser?.uid)! as String
        let catId = self.categoriesId[indexPath.row]
        
        if !self.active[self.categoriesId.index(of: catId)!] {
            self.active[self.categoriesId.index(of: catId)!] = true
            let childUpdates = [uid: true]
            ref.child("medias/\(self.imdbId)/\(catId)/votes").updateChildValues(childUpdates)
        } else {
            ref.child("medias/\(self.imdbId)/\(catId)/votes/\(uid)").removeValue()
            self.active[self.categoriesId.index(of: catId)!] = false
        }

        self.collectionView?.reloadData()
    }
}
