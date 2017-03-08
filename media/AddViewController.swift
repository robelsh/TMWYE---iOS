//
//  AddViewController.swift
//  media
//
//  Created by Etienne Jézéquel on 06/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import UIKit
import Firebase

class AddViewController: UIViewController {
    var ref: FIRDatabaseReference!
    let baseURL = "https://www.omdbapi.com"

    @IBOutlet weak var input: UITextField!
    var count:Int = 0

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.ref = FIRDatabase.database().reference()
        let user:User = User(uid: (FIRAuth.auth()?.currentUser?.uid)!, displayname: (FIRAuth.auth()?.currentUser?.displayName)!, email: (FIRAuth.auth()?.currentUser?.email)!, photoUrl: (FIRAuth.auth()?.currentUser?.photoURL?.absoluteString)!, providerID: (FIRAuth.auth()?.currentUser?.providerID)!)
        self.ref.child("users").child(user.uid).setValue(["displayName": user.displayName, "uid": user.uid, "email":user.email, "providerId":user.providerID, "photoURL": user.photoUrl])
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func getJSON(urlToRequest:String) -> Data {
        let data = try? Data(contentsOf: URL(string: urlToRequest)!)
        return data!
    }
    
    func parseJSON(inputData:Data) -> Dictionary<String,String> {
        let dictData = (try! JSONSerialization.jsonObject(with: inputData, options: .mutableContainers)) as! Dictionary<String,String>
        return dictData
    }
    
    @IBAction func add(_ sender: Any) {
        if !(self.input.text?.isEmpty)!{
            let film:String = (self.input.text?.replacingOccurrences(of: " ", with: "+"))!
            let data = parseJSON(inputData: getJSON(urlToRequest: baseURL + "/?t="+film+"&y=&plot=short&r=json"))

            let key = ref.child("medias").childByAutoId().key
            let childUpdates = ["medias/\(key)/": ["title":data["Title"],"id":key, "runtime":data["Runtime"], "genre":data["Genre"],"country":data["Country"],"released":data["Released"],"plot":data["Plot"],"poster":data["Poster"],"rating":data["imdbRating"],"year":data["Year"],"imdbId":data["imdbID"]]]
            ref.updateChildValues(childUpdates)
            self.input.text=""
        }
        dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
