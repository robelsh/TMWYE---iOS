//
//  AccountSettingsViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 09/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit

class AccountSettingsViewController: UIViewController {

    @IBOutlet weak var surnameTextField: UITextField!
    @IBOutlet weak var phoneTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var nickNameTextField: UITextField!
    @IBOutlet weak var birthDatePicker: UIDatePicker!
    
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
