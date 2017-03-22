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
    var counters:[NSNumber] = []
    var uid:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.uid = (FIRAuth.auth()?.currentUser?.uid)! as String

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
            
            for catId in self.categoriesId {
                self.ref.child("medias/\(self.imdbId)/\(catId)/votes").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
                    for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                        if child.key == self.uid {
                            self.active[self.categoriesId.index(of: catId)!] = true
                        }
                    }
                    self.collectionView?.reloadData()
                })
                
                self.ref.child("medias/\(self.imdbId)/\(catId)").queryLimited(toLast: 1).observe(.childAdded, with: { (snapshot) -> Void in
                    let count = snapshot.value as? NSNumber
                    if count != nil {
                        self.counters[self.categoriesId.index(of: catId)!] = count!
                        self.collectionView?.reloadData()
                    }
                })
                
                self.ref.child("medias/\(self.imdbId)/\(catId)").queryLimited(toLast: 1).observe(.childChanged, with: { (snapshot) -> Void in
                    let count = snapshot.value as? NSNumber
                    self.counters[self.categoriesId.index(of: catId)!] = count!
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
        cell.display(name: self.categories[indexPath.row], img: UIImage(named: self.categories[indexPath.row])!, active: self.active[indexPath.row], count: self.counters[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let catId = self.categoriesId[indexPath.row]
        
        if !self.active[self.categoriesId.index(of: catId)!] {
            self.active[self.categoriesId.index(of: catId)!] = true
            let childUpdates = [self.uid: true]
            ref.child("medias/\(self.imdbId)/\(catId)/votes").updateChildValues(childUpdates)
        } else {
            ref.child("medias/\(self.imdbId)/\(catId)/votes/\(self.uid)").removeValue()
            self.active[self.categoriesId.index(of: catId)!] = false
        }

        self.collectionView?.reloadData()
    }
}
