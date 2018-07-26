//
//  ContactListCell.swift
//  ContactApp
//
//  Created by Rajsekhar on 25/07/18.
//  Copyright © 2018 Rajsekhar. All rights reserved.
//

import UIKit

class ContactListCell: UITableViewCell {

    @IBOutlet weak var personName: UILabel!
    @IBOutlet weak var personImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = .clear
        personImage.layer.masksToBounds = true
        personImage.layer.cornerRadius = personImage.frame.size.width/2
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
