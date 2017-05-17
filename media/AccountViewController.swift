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
import SwiftyJSON

class AccountViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate{

    @IBOutlet weak var uidTextField: UILabel!
    @IBOutlet weak var emailTextField: UILabel!
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    var ref: FIRDatabaseReference!
    var user:User = User()
    let storageRef = FIRStorage.storage().reference()
    var uid:String = ""
    var imageRef:FIRStorageReference = FIRStorageReference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        SwiftSpinner.show("Loading, please wait...")

        profilePic.backgroundColor = UIColor.black
        profilePic.layer.cornerRadius = 45
        profilePic.clipsToBounds = true
        profilePic.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(importPicture)))
        profilePic.isUserInteractionEnabled = true

        self.ref = FIRDatabase.database().reference()
        self.uid = (FIRAuth.auth()?.currentUser?.uid)! as String
        self.imageRef = storageRef.child("images/"+self.uid+".jpg")

        ref.child("users").queryEqual(toValue: uid).queryOrdered(byChild: "uid").observeSingleEvent(of: .value, with: { (snapshot) -> Void in
            if let json = JSON(snapshot.value!).dictionary {
                let userData = json[self.uid]!
                self.loadUser(data: userData, uid: self.uid)
                SwiftSpinner.hide()
            }
            
        })
        ref.child("users").queryEqual(toValue: uid).queryOrdered(byChild: "uid").observe(.childChanged, with: { (snapshot) -> Void in
            let json = JSON(snapshot.value!)
            self.loadUser(data: json,uid: self.uid)
        })
        
    }

    func loadUser(data:JSON,uid:String){
        if let votes = data["votes"].dictionary {
            print(votes)
        }
        
        if let photo = data["photoURL"].string {
            self.imageRef.data(withMaxSize: 1 * 1024 * 1024) { data, error in
                if error != nil {
                    if photo != ""{
                        let photoURL = URL(string: photo)!
                        self.user.photo = try! Data(contentsOf: photoURL)
                        self.user.photoURL = photo
                    }
                } else {
                    self.user.photo = data!
                }
            }
        }
        if let displayName = data["displayName"].string {
            user.displayName = displayName
        }
        if let name = data["name"].string {
            user.name = name
        }
        if let surname = data["surname"].string {
            user.surname = surname
        }
        if let phone = data["phone"].string {
            user.phone = phone
        }
        if let providerId = data["providerId"].string {
            user.providerID = providerId
        }
        if let email = data["email"].string {
            user.email = email
        }
        if let uid = data["uid"].string {
            user.uid = uid
        }
        if let birthday = data["birthday"].string {
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
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        guard let image = info[UIImagePickerControllerEditedImage] as? UIImage else { return }
        let imageData: Data = UIImagePNGRepresentation(image)!
        dismiss(animated: true)
        
        _ = self.imageRef.put(imageData, metadata: nil) { (metadata, error) in
            guard let metadata = metadata else {
                return
            }
            _ = metadata.downloadURL
        }
        self.profilePic.image = image
    }
    
    func importPicture() {
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let svc = segue.destination as! AccountSettingsViewController;
        svc.user = self.user
    }
}
