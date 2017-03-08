//
//  DetailViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/02/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBOutlet weak var label: UILabel!
    var image:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = image
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    

 

}
