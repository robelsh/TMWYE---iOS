//
//  AccountSettingsViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 09/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class AccountSettingsViewController: UIViewController {

    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    var ref: FIRDatabaseReference!

    var user:User = User()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        surnameTextField.text = user.surname
        phoneTextField.text = user.phone
        nameTextField.text = user.name
        nickNameTextField.text = user.displayName
    }

    @IBAction func cancelSettings(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func submitSettings(_ sender: Any) {
        self.ref = FIRDatabase.database().reference()
        let key = self.user.uid
        let update = ["users/\(key)":
            ["surname":self.surnameTextField.text!,
            "name":self.nameTextField.text!,
            "displayName":self.nickNameTextField.text!,
            "phone":self.phoneTextField.text!,
            "email":self.user.email,
            "uid":self.user.uid
            ]
        ]
        ref.updateChildValues(update)
        dismiss(animated: true, completion: nil)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
