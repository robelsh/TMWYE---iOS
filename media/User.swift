//
//  User.swift
//  media
//
//  Created by Etienne Jézéquel on 08/03/2017.
//  Copyright © 2017 Etienne Jézéquel. All rights reserved.
//

import Foundation

class User {
    var displayName:String = ""
    var email:String = ""
    var photo:Data = Data()
    var uid:String = ""
    var providerID:String = ""
    var name:String = ""
    var surname:String = ""
    var phone:String = ""
    
    init(uid:String, displayname:String, email:String, photo:Data, providerID:String, name:String, surname:String, phone:String){
        self.displayName = displayname
        self.email = email
        self.photo = photo
        self.uid = uid
        self.providerID = providerID
        self.name = name
        self.surname = surname
        self.phone = phone
    }
    
    init (){
        self.displayName = ""
        self.email = ""
        self.photo = Data()
        self.uid = ""
        self.providerID = ""
        self.name = ""
        self.surname = ""
        self.phone = ""
    }
}
