//
//  ScanCollectionViewCell.swift
//  Lisaslaw
//
//  Created by user on 06/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class ScanCollectionViewCell: UICollectionViewCell {

    @IBOutlet var imageView:UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.imageView.clipsToBounds = true
        self.imageView.layer.cornerRadius = 6.0
    }

}
