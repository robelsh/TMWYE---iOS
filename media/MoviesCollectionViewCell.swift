//
//  FoodCollectionViewCell.swift
//  media
//
//  Created by Etienne Jézéquel on 10/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class MoviesCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    func display(title: String, img: UIImage){
        imageView.image = img
        self.title.text = title
    }
}
