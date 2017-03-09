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

    @IBOutlet weak var uidTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()
        profilePic.backgroundColor = UIColor.black
        profilePic.layer.cornerRadius = 45
        profilePic.clipsToBounds = true
        self.emailTextField.text = FIRAuth.auth()?.currentUser?.email
        self.uidTextField.text = FIRAuth.auth()?.currentUser?.uid

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
