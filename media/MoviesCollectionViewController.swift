//
//  MoviesCollectionViewController.swift
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

class MoviesCollectionViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout {
    var ref: FIRDatabaseReference!
    fileprivate let itemsPerRow: CGFloat = 3
    var search:Bool = false
    var genres:[String] = []
    var genresImgs:[UIImage] = []
    var genresIds:[NSNumber] = []
    var name:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading Genres, please wait...")

        self.ref = FIRDatabase.database().reference()
        ref.child("genres").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            for child in snapshot.children.allObjects as! [FIRDataSnapshot] {
                let childItem = child.value as! Dictionary<String,Any>
                
                if let name = childItem["name"] as? String {
                    self.genresImgs.append(UIImage(named: name)!)
                    self.name = name
                }
                
                if Locale.current.languageCode! == "fr" {
                    if let nameFR = childItem["nameFR"] as? String {
                        self.genres.append(nameFR)
                    }
                } else {
                    self.genres.append(self.name)
                }
                
                if let id = childItem["id"] as? NSNumber {
                    self.genresIds.append(id)
                }
            }
            self.collectionView?.reloadData()
            SwiftSpinner.hide()
        })
        self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: reuseIdentifier)
    }
    
    func getJSON(urlToRequest:String) -> Data {
        let data = try? Data(contentsOf: URL(string: urlToRequest)!)
        return data!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.genres.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> MoviesCollectionViewCell {
        let cell:MoviesCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "moviecell", for: indexPath) as! MoviesCollectionViewCell
        cell.display(title: self.genres[indexPath.row], img: self.genresImgs[indexPath.row])
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

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showGenre" {
            let list = segue.destination as! ViewController
            let cell = sender as! MoviesCollectionViewCell
            let indexPaths = self.collectionView?.indexPath(for: cell)
            list.titleView = genres[(indexPaths?.row)!]
            list.genreId = genresIds[(indexPaths?.row)!]
        }
    }

}
