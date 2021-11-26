//
//  OurTeamTableViewCell.swift
//  Lisaslaw
//
//  Created by user on 07/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class OurTeamTableViewCell: UITableViewCell {

    @IBOutlet var imgTeam:UIImageView!
    @IBOutlet var containerView:UIView!
    
    @IBOutlet var lblTeamName:UILabel!
    @IBOutlet var lblPost:UILabel!
    @IBOutlet var lblDescription:UILabel!
    
    @IBOutlet var buttonReadMore:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.containerView.clipsToBounds = true
//        self.containerView.layer.cornerRadius = 10.0
        self.imgTeam.contentMode = .scaleAspectFill
        self.imgTeam.clipsToBounds = true
        self.selectionStyle = .none
        self.buttonReadMore.clipsToBounds = true
        self.buttonReadMore.layer.cornerRadius = 6.0
        self.buttonReadMore.setTitle(Vocabulary.shared.getWordFromKey(key: "read_more"), for: .normal)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
