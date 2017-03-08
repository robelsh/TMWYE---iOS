//
//  AccountViewController.swift
//  
//
//  Created by Etienne Jézéquel on 08/03/2017.
//
//

import UIKit
import Firebase
import FirebaseAuth

class AccountViewController: UIViewController {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    override func viewDidLoad() {
        profilePic.backgroundColor = UIColor.red
        profilePic.layer.cornerRadius = 45
        profilePic.clipsToBounds = true
        super.viewDidLoad()
        if FIRAuth.auth()?.currentUser?.photoURL != nil {
            self.nameLabel.text = FIRAuth.auth()?.currentUser?.displayName
            self.profilePic.image = UIImage(data: try! Data(contentsOf:  (FIRAuth.auth()?.currentUser?.photoURL)!))
        }

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func logOutAction(_ sender: Any) {
        let firebaseAuth = FIRAuth.auth()
        do {
            try firebaseAuth?.signOut()
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
            self.present(vc!, animated: true, completion: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
