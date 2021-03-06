//
//  AuthentificationViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 08/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class SignUpViewController: UIViewController {
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var ref: FIRDatabaseReference!

    @IBAction func hideSignUp(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUp(_ sender: Any) {
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlertNetwork()
        }else {
            if emailTextField.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter your email and password", preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                
                present(alertController, animated: true, completion: nil)
                
            } else {
                FIRAuth.auth()?.createUser(withEmail: emailTextField.text!, password: passwordTextField.text!) { (user, error) in
                    
                    if error == nil {
                        self.ref = FIRDatabase.database().reference()
                        self.ref.child("users").child((FIRAuth.auth()?.currentUser?.uid)!).setValue(["uid":(FIRAuth.auth()?.currentUser?.uid)!, "email":(FIRAuth.auth()?.currentUser?.email)!, "providerId":(FIRAuth.auth()?.currentUser?.providerID)!])
                        let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                        self.present(vc!, animated: true, completion: nil)
                        
                    } else {
                        let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                        
                        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                        alertController.addAction(defaultAction)
                        self.present(alertController, animated: true, completion: nil)
                    }
                }
            }

        }
    }
    
    func displayAlertNetwork(){
        let alert = UIAlertController(title: "No Internet Connection", message: "Make sure your device is connected to the internet.", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
