//
//  ViewController.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 Rajsekhar. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {
    
    @IBOutlet weak var searchView: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var inFoView: UIView!
    @IBOutlet weak var infoPhoneNumber: UITextField!
    @IBOutlet weak var infoMail_IDTextField: UITextField!
    @IBOutlet weak var countryTextField: UITextField!
    @IBOutlet weak var infoInnerView: UIView!
    
    @IBOutlet weak var infoImageView: UIImageView!
    @IBOutlet weak var EditBtn: UIButton!
    
    @IBOutlet weak var cancelBtn: UIButton!
  
   
    @IBOutlet weak var infoName: UITextField!
    var contactList:[ContactModel] = []
    var totalContactList:[ContactModel] = []
    var refHandle:DatabaseHandle!
    var instance : FireBaseDataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        searchView.backgroundColor = .groupTableViewBackground
        instance = FireBaseDataModel.shareInstance
        infoInnerView.layer.cornerRadius = 10.0
//        EditBtn.layer.cornerRadius = 5.0
        cancelBtn.layer.cornerRadius = 5.0
        searchView.layer.cornerRadius = 15.0;
        searchView.layer.borderWidth = 0.5
        searchView.backgroundColor = UIColor.white
        searchView.barTintColor = UIColor.white
        self.title = "Contacts"
        self.view.backgroundColor = .groupTableViewBackground
        tableView.separatorColor = .clear
        tableView.backgroundColor = UIColor.groupTableViewBackground
        inFoView.isHidden = true
        DispatchQueue.global(qos: .userInitiated).async {
            self.instance.ref.observe(.childAdded, with: { (data) in
                let value = data.value as? NSDictionary
                if let snapSotValue = value {
                self.contactList.append(ContactModel(name:snapSotValue["name"] as! String, image:snapSotValue["image"]as! String, mail: snapSotValue["email"]as! String, phoneNumber: snapSotValue["PhoneNumber"]as! String, countryName: snapSotValue["contry"]as! String))
                    //self.contactList.add(snapSotValue)
                }
                DispatchQueue.main.async {
                    self.totalContactList = self.contactList
                    self.tableView.reloadData()
                }
            }) }}
    
    @IBAction func addNewContactBarButtonAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "addNewContact", sender: self)
    }
    @IBAction func editBtnAction(_ sender: Any) {
         performSegue(withIdentifier: "addNewContact", sender: self)
    }
    @IBAction func cancelBtnAction(_ sender: Any) {
        inFoView.isHidden = true
    }
    
    
}
extension ViewController: UITableViewDelegate,UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if totalContactList.count > 1 {
            searchView.isHidden = false
        }else{
            searchView.isHidden = true
        }
        return totalContactList.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactlistCell", for: indexPath) as? ContactListCell
        let dict:ContactModel = totalContactList[indexPath.row]
        if let cell = cell{
           
            cell.personName.text = dict.name!
            cell.personImage.layer.cornerRadius = cell.personImage.frame.size.width/2
            
            if  let stringData:String = dict.image{
                let imageData = Data(base64Encoded: stringData.data(using: .utf8)!, options: NSData.Base64DecodingOptions(rawValue: 0))
                if let mageUIImage = UIImage(data: imageData!) {
                    cell.personImage.image = mageUIImage
                }}}
        
        return cell!
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactlistCell", for: indexPath) as? ContactListCell
        let dict:ContactModel = totalContactList[indexPath.row]
        infoName.text = dict.name
        infoPhoneNumber.text = dict.phoneNumber
        countryTextField.text = dict.countryName
        infoMail_IDTextField.text = dict.mail
          infoImageView.layer.cornerRadius = infoImageView.frame.size.width/2
        if  let stringData:String = dict.image{
            let imageData = Data(base64Encoded: stringData.data(using: .utf8)!, options: NSData.Base64DecodingOptions(rawValue: 0))
            if let mageUIImage = UIImage(data: imageData!) {
                infoImageView.image = mageUIImage
            }}
        inFoView.isHidden = false
    }
    
}
extension ViewController :UISearchDisplayDelegate,UISearchBarDelegate{
    func searchBar(_ searchBar: UISearchBar, textDidChange text: String) {
        if (text == "") {
            totalContactList = contactList
            tableView.reloadData()
        } else {
            searchThroughdata()
        }}
    func searchThroughdata() {
        totalContactList = self.contactList.filter({$0.name!.lowercased().contains(searchView.text!.lowercased())})
        tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
        // You can write search code Here
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        totalContactList = contactList
        tableView.reloadData()
    }
}

