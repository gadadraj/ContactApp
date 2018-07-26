//
//  CoreData.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 Rajsekhar. All rights reserved.
//

import Foundation
import CoreData
import UIKit
class CoreData: NSObject {
    
    //MARK :- Fetching Data From  CoreData
    static func fetchDetailsFormDb(entityName:String)->[NSManagedObject] {
        var  contacts = [NSManagedObject]()
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName:entityName)
        do {
            contacts = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
        } catch let error as NSError {
            print("Could not fetch. \(error)")
        }
        return contacts
    }

    static func saveIfExist(entityName:String){
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:entityName, in: managedObjectContext)
        let contact = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        contact.setValue("true", forKey: "isExist")
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
    
    
    static func saveNonImageContacts(name: String,code:String,entityName:String,firstObject:String,secondObject:String) {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedObjectContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName:entityName, in: managedObjectContext)
        let contact = NSManagedObject(entity: entity!, insertInto: managedObjectContext)
        contact.setValue(name, forKey: firstObject)
        contact.setValue(code, forKey: secondObject)
        do {
            try managedObjectContext.save()
            
        } catch let error as NSError {
            print("Couldn't save. \(error)")
        }
    }
}


