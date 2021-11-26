//
//  ContactUSTableViewCell.swift
//  Lisaslaw
//
//  Created by user on 18/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
protocol HomeTableViewContactUsDelegate {
    func loadUpdateWebURLSelector(strURL:String)
    func blogSelector()
    func loadWechatpopup()
}
class ContactUSTableViewCell: UITableViewCell {

    
    @IBOutlet var iconImageView:UIImageView!
    @IBOutlet var lblName:UILabel!
    
    @IBOutlet var contactusContainer:UIView!
    
    @IBOutlet var socialMediaContainer:RoundedView!
    @IBOutlet var callContainer:RoundedView!
    @IBOutlet var blogContainer:RoundedView!
    @IBOutlet var findUsContainer:RoundedView!
    
    var delegate:HomeTableViewContactUsDelegate?

    @IBOutlet var buttonFaceBook:UIButton!

    
    @IBOutlet var imgFaceBook:UIImageView!
    @IBOutlet var imgLinkedin:UIImageView!
    @IBOutlet var imgTwitter:UIImageView!
    @IBOutlet var txtBlog:UITextView!
    @IBOutlet var txtAddress:UITextView!
    @IBOutlet var imageRightDropArrow:UIImageView!
    
    @IBOutlet var leadingConstaintFaceBook:NSLayoutConstraint!
    @IBOutlet var containerWeChat:UIView!
    @IBOutlet var containerWebio:UIView!
    @IBOutlet var containerYoutube:UIView!
    @IBOutlet var buttonWeChat:UIButton!
    @IBOutlet var buttonWebio:UIButton!
    @IBOutlet var buttonYoutube:UIButton!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.selectionStyle = .none
        self.imgFaceBook.addTintColor(color: kFacebookColor)
        self.imgLinkedin.addTintColor(color: kLinkedinColor)
        self.imgTwitter.addTintColor(color: kTwitterColor)
        self.backgroundColor = UIColor.white
    }
    func callLocatization(){
        self.socialMediaContainer.text =  Vocabulary.shared.getWordFromKey(key:"social_media")
        self.findUsContainer.text =  Vocabulary.shared.getWordFromKey(key:"find_us")
        self.socialMediaContainer.updateView()
        self.findUsContainer.updateView()
        self.txtBlog.text = Vocabulary.shared.getWordFromKey(key:"blog")
        self.txtAddress.text = "\(Vocabulary.shared.getWordFromKey(key:"lisa_law"))\n\(Vocabulary.shared.getWordFromKey(key:"lisa_address"))"
    }
    func configureSelectedLanguage(){
        if String.getSelectedLanguage() == "1"{ //english
            self.containerWeChat.isHidden = true
            self.buttonWeChat.isHidden = true
            self.containerWebio.isHidden = true
            self.buttonWebio.isHidden = true
            self.containerYoutube.isHidden = false
            self.buttonYoutube.isHidden = false
            self.leadingConstaintFaceBook.constant = 15.0
        }else{//chinese
            self.containerWeChat.isHidden = false
            self.buttonWeChat.isHidden = false
            self.containerWebio.isHidden = false
            self.buttonWebio.isHidden = false
            self.containerYoutube.isHidden = true
            self.buttonYoutube.isHidden = true
            self.leadingConstaintFaceBook.constant = 150.0
        }
    }
    @IBAction func buttonBLogSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.blogSelector()
        }
    }
    @IBAction func buttonWeChatSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadWechatpopup()
        }
    }
    @IBAction func buttonWeiboSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadUpdateWebURLSelector(strURL:kLisaWeibo)
        }
    }
    
    @IBAction func buttonFaceBookSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadUpdateWebURLSelector(strURL:kLisaFacebook)
        }
    }
    @IBAction func buttonTwitterSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadUpdateWebURLSelector(strURL:kLisaTwiiter)
        }
    }
    @IBAction func buttonLinkedinSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadUpdateWebURLSelector(strURL:kLisaLinkedin)
        }
    }
    @IBAction func buttonYoutubeSelector(sender:UIButton){
        if let _ = self.delegate{
            self.delegate!.loadUpdateWebURLSelector(strURL:(String.getSelectedLanguage() == "1") ? kYoutubeEnglish : kYoutubeChinese)
        }
    }
    @IBAction func buttonCallSelector(sender:UIButton){
        let number = "02079280276"
        if let url = URL(string: "tel://\(number)"),
           UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler:nil)
           } else {
                    // add error message here
           }
        }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
