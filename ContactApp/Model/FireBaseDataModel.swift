//
//  FireBaseDataModel.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 Rajsekhar. All rights reserved.
//

import UIKit
import Firebase
class FireBaseDataModel: NSObject {
    var ref: DatabaseReference!
    static var shareInstance:FireBaseDataModel = FireBaseDataModel()
    
    override init() {
        ref = Database.database().reference()
        ref = Database.database().reference().child("contactapp")
    }
    
}
