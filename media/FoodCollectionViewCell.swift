//
//  FoodCollectionViewCell.swift
//  media
//
//  Created by Etienne Jézéquel on 10/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class FoodCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var title: UILabel!
    
    func display(title: String, color: UIColor){
        self.title.text = title
        self.backgroundColor = color
    }
}
