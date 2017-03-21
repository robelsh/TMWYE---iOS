//
//  VoteCollectionViewCell.swift
//  media
//
//  Created by Etienne Jézéquel on 20/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class VoteCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var catImage: UIImageView!
    @IBOutlet weak var catNameLabel: UILabel!
    var active: Bool = false
    
    func display(name: String, img: UIImage, active: Bool){
        catImage.image = img
        catNameLabel.text = name
        if active {
            self.backgroundColor = UIColor.white
        } else {
            self.backgroundColor = UIColor.gray
        }
    }
}
