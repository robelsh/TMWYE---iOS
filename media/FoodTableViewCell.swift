//
//  FoodTableViewCell.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Alamofire

class FoodTableViewCell: UITableViewCell {

    @IBOutlet weak var img: UIImageView!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func display(data:Movie){
        self.yearLabel.text = data.year
        self.label.text = data.title
        Alamofire.request("https://image.tmdb.org/t/p/w500"+data.posterURL).responseData(){ response in
            self.img.image = UIImage(data: response.result.value!)
        }
    }

}
