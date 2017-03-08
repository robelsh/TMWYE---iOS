//
//  User.swift
//  media
//
//  Created by Etienne Jézéquel on 08/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import Foundation

class User {
    var displayName:String
    var email:String
    var photoUrl:String
    var uid:String
    var providerID:String
    
    init(uid:String, displayname:String, email:String, photoUrl:String, providerID:String){
        self.displayName = displayname
        self.email = email
        self.photoUrl = photoUrl
        self.uid = uid
        self.providerID = providerID
    }
}
