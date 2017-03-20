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
    
    func display(name: String, img: UIImage){
        catImage.image = img
        catNameLabel.text = name
    }
}
