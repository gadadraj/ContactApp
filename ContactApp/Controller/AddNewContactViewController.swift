//
//  AddNewContactViewController.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 Rajsekhar. All rights reserved.
//

import UIKit
import CoreData
class AddNewContactViewController: UIViewController, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
    
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var firstNameTextFld: UITextField!
    @IBOutlet weak var lastNameTextFld: UITextField!
    @IBOutlet weak var emailTextFld: UITextField!
    @IBOutlet weak var phoneNumbertextFld: UITextField!
    @IBOutlet weak var countryCodeTextFeld: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    @IBOutlet weak var c_CTextField: UITextField!
    @IBOutlet weak var scrollView: UIScrollView!
    var imagePicker = UIImagePickerController()
    var activeField: UITextField?
    var cntryNames:[String] = []
    var contacts: [NSManagedObject] = []
    var tableArray:String = ""
    var pickerView = UIPickerView()
    var toolBar = UIToolbar()
  //  let sharedInstance = MakeApiCall.sharedInstance
    var instance : FireBaseDataModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        let existData = CoreData.fetchDetailsFormDb(entityName: "CountryExist")
        if(existData.count > 0){
           self.contacts = CoreData.fetchDetailsFormDb(entityName:"Contacts")
        }else{
            callingApi()
        }
        instance = FireBaseDataModel.shareInstance
        loadViewInterFace()
        loadPickerView()
      }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
       
    }
    override func viewDidLayoutSubviews() {
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius =  imageView.bounds.size.width/2
        firstNameTextFld.setBottomBorder();lastNameTextFld.setBottomBorder();emailTextFld.setBottomBorder();phoneNumbertextFld.setBottomBorder();countryCodeTextFeld.setBottomBorder()
        view.setNeedsLayout()
    }
    
    func loadViewInterFace(){
       
        self.title = "Add Contact"
        self.view.backgroundColor = .groupTableViewBackground
        saveButton.layer.cornerRadius = 15.0
        saveButton.addTarget(self, action: #selector(saveDetailsAction), for: .touchUpInside)
        
        imagePicker.delegate = self
        
        
        
    }
    
    func loadPickerView(){
//        toolBar.backgroundColor = UIColor.black
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor.black
        toolBar.sizeToFit()
        pickerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 216)
        pickerView.delegate = self
        pickerView.dataSource = self
        let leftBarButton = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(didTapOnBarButton))
         let middleBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
         let rightBarButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(didTapOnBarButton))
        toolBar.setItems([ leftBarButton,middleBarButton,rightBarButton], animated: false)
        toolBar.isUserInteractionEnabled = true

        countryCodeTextFeld.inputAccessoryView = toolBar
        countryCodeTextFeld.inputView = pickerView
    }
    
    @objc func didTapOnBarButton(){
    countryCodeTextFeld.resignFirstResponder()
    }
    
    @IBAction func imageSelectButtonAction(_ sender: UITapGestureRecognizer) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    func openCamera() {
        
        if(UIImagePickerController .isSourceTypeAvailable(UIImagePickerControllerSourceType.camera)) {
            imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//            imagePicker.allowsEditing = true
            self.present(imagePicker, animated: true, completion: nil)
        }
        else {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    func openGallery() {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum){
            print("Button capture")
            
            imagePicker.delegate = self
            imagePicker.sourceType = .savedPhotosAlbum;
            imagePicker.allowsEditing = false
            
            self.present(imagePicker, animated: true, completion: nil)
        }
    }
    
//    func imagePickerController(picker: UIImagePickerController!, didFinishPickingImage image: UIImage!, editingInfo: NSDictionary!){
//        self.dismiss(animated: true, completion: { () -> Void in
//
//        })
//
//        imageView.image = image
//    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        if let pickedImage = info[UIImagePickerControllerOriginalImage] as? UIImage {
//             imageView.layer.cornerRadius = self.imageView.bounds.size.width/2
//            imageView.layer.masksToBounds = true
//            imageView.layoutIfNeeded()
            imageView.contentMode = .scaleToFill
            imageView.image = pickedImage
        }
        picker.dismiss(animated: true, completion: nil)
    }
    
    @objc func saveDetailsAction() {
        if imageView.image != nil {
            var data = Data()
            data = UIImageJPEGRepresentation(imageView.image!, 0.5)!
            let encryptedDataText:String = data.base64EncodedString(options: NSData.Base64EncodingOptions())
            
            let key = instance.ref.childByAutoId().key
            
            if firstNameTextFld.text != "" && lastNameTextFld.text != "" && emailTextFld.text != "" && phoneNumbertextFld.text != ""{
//                && countryCodeTextFeld.text != ""{
                let artist = ["id":key,
                              "name"   : self.firstNameTextFld.text! + " " + self.lastNameTextFld.text!,
                              "PhoneNumber" : phoneNumbertextFld.text!,
                              "email"       : emailTextFld.text!,
                              "contry"      : "IN",//countryCodeTextFeld.text!,
                              "image"       : encryptedDataText]
                instance.ref.child(key).setValue(artist)
                self.navigationController?.popViewController(animated:true )
                
            }}}}

extension AddNewContactViewController:UITextFieldDelegate{
    @objc func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
//        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    @objc  func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        self.scrollView.isScrollEnabled = false
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField){
        activeField = textField
        if textField == countryCodeTextFeld{
            
            self.loadPickerView()
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    func textFieldDidEndEditing(_ textField: UITextField){
        activeField = nil
    }
    
    func callingApi () {
        let query = "https://restcountries.eu/rest/v1/all"
        
        APIService.callTheGetApi(url: query) { (result) in
            guard result.count > 0 else { return  }
            for i in 0..<result.count {
                let dicts = result[i]
                let name = dicts["name"]
                if let array = dicts["callingCodes"] as? [AnyObject] {
                    for name in array{
                        self.tableArray = name as! String
                    }
                }
                CoreData.saveNonImageContacts(name: name as! String, code: self.tableArray , entityName: "Contacts", firstObject: "countryCode", secondObject: "countryName")
                CoreData.saveIfExist(entityName: "CountryExist")
            }
            DispatchQueue.main.async {
                self.contacts = CoreData.fetchDetailsFormDb(entityName:"Contacts")
                
            }
        }
    }
    
    
   

    
}
extension AddNewContactViewController:UIPickerViewDataSource,UIPickerViewDelegate {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return contacts.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let kundObj = self.contacts[row]
        return "\(kundObj.value(forKey: "countryName") as! String)     \(kundObj.value(forKey: "countryCode") as! String)"
        
        
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let kundObj = self.contacts[row]
        countryCodeTextFeld.text = kundObj.value(forKey: "countryCode") as? String
        let countryCode =  kundObj.value(forKey: "countryName") as! String
        c_CTextField.text = "+" + countryCode + " - "
    }
}

