//
//  MainViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 09/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class MainViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        if Reachability.isConnectedToNetwork() != true {
            self.displayAlertNetwork()
        } else {
            FIRAuth.auth()?.addStateDidChangeListener() { (auth, user) in
                if (user != nil) {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Home")
                    self.present(vc!, animated: false, completion: nil)
                } else {
                    let vc = self.storyboard?.instantiateViewController(withIdentifier: "Login")
                    self.present(vc!, animated: false, completion: nil)
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
