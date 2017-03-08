//
//  AddViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    var ref: FIRDatabaseReference!

    @IBOutlet weak var input: UITextField!
    var count:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func add(_ sender: Any) {
        if !(self.input.text?.isEmpty)!{
            let film = self.input.text?.replacingOccurrences(of: " ", with: "+")
            let key = ref.child("medias").childByAutoId().key
            let childUpdates = ["medias/\(key)/": ["name":film]]
            ref.updateChildValues(childUpdates)
            self.input.text=""
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
