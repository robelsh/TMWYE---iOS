//
//  LoginViewController.swift
//  
//
//  Created by Etienne Jézéquel on 08/03/2017.
//
//

import UIKit
import Firebase
import GoogleSignIn
import FacebookLogin
import FacebookCore

class LoginViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var loginTextField: UITextField!
    @IBOutlet weak var logInGoogle: GIDSignInButton!
    
    var ref: FIRDatabaseReference!

    @IBAction func logIn(_ sender: Any) {
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlertNetwork()
        } else {
            if self.loginTextField.text == "" || self.passwordTextField.text == "" {
                let alertController = UIAlertController(title: "Error", message: "Please enter an email and password.", preferredStyle: .alert)
                let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            } else {
                FIRAuth.auth()?.signIn(withEmail: self.loginTextField.text!, password: self.passwordTextField.text!) { (user, error) in
                
                    if error == nil {
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
        let loginButton = LoginButton(readPermissions: [ .publicProfile ])
        loginButton.center = view.center
        view.addSubview(loginButton)

        if Reachability.isConnectedToNetwork() != true {
            self.displayAlertNetwork()
        }
        
        GIDSignIn.sharedInstance().uiDelegate = self
        FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
            if (user != nil) {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                self.present(vc!, animated: false, completion: nil)
            }
        }
        //let credential = FIRFacebookAuthProvider.credential(withAccessToken: (AccessToken.current?.authenticationToken)!)

    }

    
    @IBAction func logInFacebook(_ sender: Any) {
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlertNetwork()
        }else {
            let loginManager = LoginManager()
            loginManager.logIn([ .publicProfile ], viewController: self) { loginResult in
                switch loginResult {
                case .failed(let error):
                    print(error)
                case .cancelled:
                    print("User cancelled login.")
                case .success(let grantedPermissions, let declinedPermissions, let accessToken):
                    print("Logged in!")
                }
            }
        }
    }
    
    @IBAction func logInGoogle(_ sender: Any) {
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlertNetwork()

        }else {
            GIDSignIn.sharedInstance().signIn()
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "reset" {
            let destination = segue.destination as! ResetViewController
            destination.email = self.loginTextField.text!
        }
    }
}
