//
//  AboutUsTableViewCell.swift
//  Lisaslaw
//
//  Created by user on 08/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AboutUsTableViewCell: UITableViewCell {

    @IBOutlet var lblAboutUs:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.backgroundColor = UIColor.white
        self.lblAboutUs.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
