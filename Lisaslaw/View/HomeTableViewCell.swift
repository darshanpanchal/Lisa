//
//  HomeTableViewCell.swift
//  Lisaslaw
//
//  Created by user on 04/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
protocol HomeTableViewDelegate {
    func loadWebURLSelector(strURL:String)
}
class HomeTableViewCell: UITableViewCell {
    
    @IBOutlet var shadowView:ShadowView!
    @IBOutlet var containerView:UIView!
    @IBOutlet var subContainerView:UIView!
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var lblName:UILabel!

    
    @IBOutlet var socialMediaContainer:UIView!
    @IBOutlet var contactUsContainer:UIView!
    @IBOutlet var connectToOspreyContainer:UIView!
    
    @IBOutlet var textViewContactUS:UITextView!
    
    @IBOutlet var imgFaceBook:UIImageView!
    @IBOutlet var imgLinkedin:UIImageView!
    @IBOutlet var imgTwitter:UIImageView!
    
    
    @IBOutlet var lblConnectToOsprey:UILabel!
    @IBOutlet var buttonConnectToOsprey:UIButton!
    @IBOutlet var txtConnectToOsprey:UITextView!
    @IBOutlet var shadowButton:ShadowView!
    

    var delegate:HomeTableViewDelegate?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        //        self.layer.borderColor = UIColor.init(hexString: "757575").cgColor
        //        self.layer.borderWidth = 0.75
        self.clipsToBounds = true
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 10.0
        self.shadowView.layer.cornerRadius = 10.0
        self.iconImageView.backgroundColor = kThemeColor
        //configure image view
        self.iconImageView.layer.cornerRadius = 6.0//self.iconImageView.bounds.size.height/2
        self.iconImageView.layer.masksToBounds = true
        self.iconImageView.clipsToBounds = true
        self.textViewContactUS.linkTextAttributes = [NSAttributedString.Key.foregroundColor:kThemeColor]
        
        self.imgFaceBook.addTintColor(color: kFacebookColor)
        self.imgLinkedin.addTintColor(color: kLinkedinColor)
        self.imgTwitter.addTintColor(color: kTwitterColor)
        
        self.buttonConnectToOsprey.layer.cornerRadius = 6.0
        self.shadowButton.layer.cornerRadius = 10.0
        
        self.backgroundColor = UIColor.white
       
    }
    func setUp(){
         self.textViewContactUS.text = "020 7928 0276\n\ninfo@lisaslaw.co.uk\n\n\(Vocabulary.shared.getWordFromKey(key: "lisa_law"))\n\(Vocabulary.shared.getWordFromKey(key:"lisa_address"))\nLondon SE1 6JZ"
        self.txtConnectToOsprey.text = "\(Vocabulary.shared.getWordFromKey(key: "connect_ospreyDetail"))"
        self.buttonConnectToOsprey.setTitle("\(Vocabulary.shared.getWordFromKey(key: "continue"))", for: .normal)
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func buttonFaceBookSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadWebURLSelector(strURL:kLisaFacebook)
        }
    }
    @IBAction func buttonTwitterSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadWebURLSelector(strURL:kLisaTwiiter)
        }
    }
    @IBAction func buttonLinkedinSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadWebURLSelector(strURL:kLisaLinkedin)
        }
    }
    
    
}
extension UIImageView{
    func addTintColor(color:UIColor){
        self.image = self.image?.withRenderingMode(.alwaysTemplate)
        self.tintColor = color
    }
}
class ShadowView:UIView{
    private var theShadowLayer: CAShapeLayer?
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let rounding = CGFloat.init(10.0)
        var shadowLayer = CAShapeLayer.init()
        shadowLayer.name = "ShadowLayer1"
        shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: rounding).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowColor = UIColor.init(red: 60.0/255.0, green: 64.0/255.0, blue: 67.0/255.0, alpha:0.3).cgColor
        shadowLayer.shadowRadius = CGFloat.init(2.0)
        shadowLayer.shadowOpacity = Float.init(0.5)
        shadowLayer.shadowOffset = CGSize.init(width: 0.0, height: 1.0)
        if  let arraySublayer1:[CALayer] = self.layer.sublayers?.filter({$0.name == "ShadowLayer1"}),let sublayer1 =  arraySublayer1.first{
            sublayer1.removeFromSuperlayer()
        }
        self.layer.insertSublayer(shadowLayer, below: nil)
        shadowLayer = CAShapeLayer.init()
        shadowLayer.name = "ShadowLayer2"
        shadowLayer.path = UIBezierPath.init(roundedRect: bounds, cornerRadius: rounding).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowColor = UIColor.init(red: 60.0/255.0, green: 64.0/255.0, blue: 67.0/255.0, alpha:0.15).cgColor
        shadowLayer.shadowRadius = CGFloat.init(6.0)
        shadowLayer.shadowOpacity = Float.init(0.5)
        shadowLayer.shadowOffset = CGSize.init(width: 0.0, height: 2.0)
        if  let arraySublayer2:[CALayer] = self.layer.sublayers?.filter({$0.name == "ShadowLayer2"}),let sublayer2 =  arraySublayer2.first{
            sublayer2.removeFromSuperlayer()
        }
        self.layer.insertSublayer(shadowLayer, below: nil)
        
    }
}
class RoundButton:UIButton{
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = self.bounds.size.height/2
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        
    }
}
