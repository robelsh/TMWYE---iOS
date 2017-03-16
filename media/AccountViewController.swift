//
//  AccountViewController.swift
//  
//
//  Created by Etienne Jézéquel on 08/03/2017.
//
//

import UIKit
import Firebase
import SwiftSpinner

class AccountViewController: UIViewController {

    @IBOutlet weak var uidTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var ref: FIRDatabaseReference!
    var user:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading, please wait...")

        profilePic.backgroundColor = UIColor.black
        profilePic.layer.cornerRadius = 45
        profilePic.clipsToBounds = true
        
        self.ref = FIRDatabase.database().reference()
        let uid = (FIRAuth.auth()?.currentUser?.uid)! as String
        
        ref.child("users").queryEqual(toValue: uid).queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            let userDict:Dictionary<String,Dictionary<String,String>> = snapshot.value as! Dictionary<String,Dictionary<String,String>>
            let userData = userDict[uid]
            self.loadUser(snapshot: userData!,uid: uid)
            SwiftSpinner.hide()
        })
        ref.child("users").queryEqual(toValue: uid).queryOrdered(byChild: "uid").observe(.childChanged, with: { (snapshot) -> Void in
            self.loadUser(snapshot: snapshot.value as! Dictionary<String,String>,uid: uid)
        })
    }

    func loadUser(snapshot:Dictionary<String,String>,uid:String){
        if let photo = snapshot["photoURL"] {
            if photo != ""{
                let photoURL = URL(string: photo)!
                user.photo = try! Data(contentsOf: photoURL)
                user.photoURL = photo
            }
        }
        if let displayName = snapshot["displayName"] {
            user.displayName = displayName
        }
        if let name = snapshot["name"] {
            user.name = name
        }
        if let surname = snapshot["surname"] {
            user.surname = surname
        }
        if let phone = snapshot["phone"] {
            user.phone = phone
        }
        if let providerId = snapshot["providerId"] {
            user.providerID = providerId
        }
        if let email = snapshot["email"] {
            user.email = email
        }
        if let uid = snapshot["uid"] {
            user.uid = uid
        }
        if let birthday = snapshot["birthday"] {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd-mm-yy"
            let date = dateFormatter.date(from: birthday)
            user.birthday = date!
        }
        self.updateUserView()
    }
    
    func updateUserView(){
        self.emailTextField.text = user.email
        self.uidTextField.text = user.uid
        self.nameLabel.text = user.displayName
        self.profilePic.image = UIImage(data: user.photo)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let svc = segue.destination as! AccountSettingsViewController;
        svc.user = self.user
    }
}
