//
//  HelperClass.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 AddTech. All rights reserved.
//

import Foundation
import UIKit

extension UITextField{
    func setBottomBorder() {
    let border = CALayer()
    let width = CGFloat(1.0)
    self.backgroundColor = UIColor.clear
    self.borderStyle = .none
    border.borderColor = UIColor.darkGray.cgColor
    border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.bounds.size.width, height: self.frame.size.height)
    border.borderWidth = width
    self.layer.addSublayer(border)
    self.layer.masksToBounds = true
    }
}
class APIService: NSObject {
    
    /// CALLING THE Get METHOD API
    static func callTheGetApi(url:String,completion: @escaping ([[String:AnyObject]])->() ) {
        guard let url = URL(string: url) else { return}
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return  }
            guard let data = data else { return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [[String:AnyObject]] {
                    
                    DispatchQueue.main.async {
                        completion(json )
                    }
                }
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            }.resume()
    }
    
    /// CALLING THE POST METHOD API
    
    static func callThePostApi(url:String,params: [String: AnyObject],completion: @escaping ([String: AnyObject])->() ) {
        guard let url = URL(string: url) else { return}
        let request = NSMutableURLRequest(url: url as URL)
        request.httpMethod = "POST"
        request.setValue("token", forHTTPHeaderField: "QpwL5tke4Pnpja7X")
        let jsonData = try? JSONSerialization.data(withJSONObject: params)
        request.httpBody = jsonData
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard error == nil else { return  }
            guard let data = data else { return}
            do {
                if let json = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers]) as? [String: AnyObject] {
                    
                    DispatchQueue.main.async {
                        completion(json)
                    }
                }
            }
            catch let error as NSError {
                print("json error: \(error.localizedDescription)")
            }
            }.resume()
    }
    
    
}

import UIKit

struct CountryName: Codable {
    let title: String
    let description: String
}
