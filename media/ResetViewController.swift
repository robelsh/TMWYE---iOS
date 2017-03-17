//
//  ResetViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 17/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class ResetViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    var email:String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.emailTextField.text = self.email
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func submitReset(_ sender: Any) {
        if let email = emailTextField.text {
            FIRAuth.auth()?.sendPasswordReset(withEmail: email) { (error) in
                if error != nil{
                    let alertController = UIAlertController(title: "Error", message: error?.localizedDescription, preferredStyle: .alert)
                    let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                    alertController.addAction(defaultAction)
                    self.present(alertController, animated: true, completion: nil)
                } else {
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }

    @IBAction func hideReset(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reset" {
            let destination = segue.destination as! LoginViewController
            destination.loginTextField.text = ""
        }
    }
}
