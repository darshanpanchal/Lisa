//
//  OurTeamDetailTableViewCell.swift
//  Lisaslaw
//
//  Created by user on 08/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class OurTeamDetailTableViewCell: UITableViewCell {

    @IBOutlet var lblTitle:UILabel!
    @IBOutlet var lblPost:UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.lblTitle.textColor = kThemeLightColor
        self.backgroundColor = UIColor.white
        self.lblPost.textColor = UIColor.black
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
