//
//  ContactModel.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 Rajsekhar. All rights reserved.
//

import Foundation
class ContactModel:NSObject {
  
    var name :String?
    var image :String?
    var mail :String?
    var phoneNumber :String?
    var countryName:String?
    
init(name:String,image:String,mail:String,phoneNumber:String,countryName:String) {
        self.name = name
        self.image = image
        self.phoneNumber = phoneNumber
        self.countryName = countryName
        self.mail = mail
    }
}
