//
//  FoodCollectionViewCell.swift
//  media
//
//  Created by Etienne Jézéquel on 10/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var title: UILabel!
    
    func display(title: String, img: UIImage){
        button.setImage(img, for: .normal)
        self.title.text = title
    }
}
