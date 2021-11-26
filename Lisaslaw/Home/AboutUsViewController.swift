//
//  AboutUsViewController.swift
//  Lisaslaw
//
//  Created by user on 08/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class AboutUsViewController: UIViewController {

    @IBOutlet var lblTitle:UILabel!
    
    @IBOutlet var tableViewAboutUS:UITableView!
    @IBOutlet var headerImageView:UIImageView!
    @IBOutlet var headerBackgroundImage:UIImageView!
    
    @IBOutlet var lblOurTeam:UILabel!
    
    @IBOutlet var bottomContainer:UIView!
    @IBOutlet var bottomConstraint:NSLayoutConstraint!
    
    lazy var arrayOfDetail:[String] = ["\(Vocabulary.shared.getWordFromKey(key: "about_us_detail1"))","\(Vocabulary.shared.getWordFromKey(key: "about_us_detail2"))","\(Vocabulary.shared.getWordFromKey(key: "checkout"))(https://cdn.buttercms.com/qmzQOCNITrCh555uVdks).","\(Vocabulary.shared.getWordFromKey(key: "youtube_channel"))(https://www.youtube.com/channel/UCPmpxpJNXwSfgy7_z6ljKmg/featured)"]
    
    
    lazy var isOurTeam:Bool = false
    var objTeam:OurTeamModel?
    lazy private var lastContentOffset: CGFloat = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        // Do any additional setup after loading the view.
        self.configureTableView()
    }
    // MARK: - Custom Methods
    func setUp(){
        self.lblOurTeam.text = Vocabulary.shared.getWordFromKey(key: "our_team")
        self.headerImageView.clipsToBounds = true
        self.headerImageView.contentMode = self.isOurTeam ? .scaleAspectFill : .scaleAspectFill//.scaleToFill
        self.headerBackgroundImage.isHidden = !(self.isOurTeam)
        
        self.bottomContainer.isHidden = self.isOurTeam
        self.bottomConstraint.constant = (self.isOurTeam) ? 0 : 100.0
        if self.isOurTeam{
            
            self.lblTitle.text = ""
            if let _ = self.objTeam{
                self.headerImageView.image = UIImage.init(named: "test\(objTeam!.id)")//UIImage.init(named: "\(self.objTeam!.imageName)")
//                self.headerBackgroundImage.image = UIImage.init(named: "\(self.objTeam!.imageName)")
            }
        }else{
            self.lblTitle.text = "\(Vocabulary.shared.getWordFromKey(key: "about_us"))"
            self.headerImageView.image = UIImage.init(named: "about_us_background")
        }
    }
    func configureTableView(){
        self.tableViewAboutUS.rowHeight = UITableView.automaticDimension
        self.tableViewAboutUS.estimatedRowHeight = 50.0
        let objNib = UINib.init(nibName: "AboutUsTableViewCell", bundle: nil)
        self.tableViewAboutUS.register(objNib, forCellReuseIdentifier: "AboutUsTableViewCell")
        let objNibTitle = UINib.init(nibName: "OurTeamDetailTableViewCell", bundle: nil)
        self.tableViewAboutUS.register(objNibTitle, forCellReuseIdentifier: "OurTeamDetailTableViewCell")
        self.tableViewAboutUS.delegate = self
        self.tableViewAboutUS.dataSource = self
        self.tableViewAboutUS.reloadData()
        self.tableViewAboutUS.contentInset = UIEdgeInsets.init(top: -UIApplication.shared.keyWindow!.safeAreaInsets.top, left: 0, bottom: 0, right: 0)
        self.tableViewAboutUS.reloadData()
        self.tableViewAboutUS.separatorStyle = .none
    }
    // MARK: - Selector Methods
    @IBAction func buttonBackSelector(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonOurTeamSelector(sender:UIButton){
        self.pushToOurTeamController()
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    func pushToOurTeamController(){
        if let ourTeamViewConroller = self.storyboard?.instantiateViewController(withIdentifier: "OurTeamViewController") as? OurTeamViewController{
            self.navigationController?.pushViewController(ourTeamViewConroller, animated: true)
        }
    }
    func pushToYouTubeScreenWithURL(strURL:String){
        if let objViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebLoadViewController") as? WebLoadViewController{
            objViewController.objURLString = strURL
            objViewController.isBlog = true
            self.navigationController?.pushViewController(objViewController, animated: true)
        }
    }
}
extension AboutUsViewController:UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate{

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if self.isOurTeam{
            return 2
        }else{ //about US
            return self.arrayOfDetail.count
        }
        
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y >= 0{
            self.lblTitle.textColor = UIColor.white
        }else if scrollView.contentOffset.y < -54{
            self.lblTitle.textColor = UIColor.black
        }else{
            self.lblTitle.textColor = UIColor.white
        }
        
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if self.isOurTeam{
            if indexPath.row == 0{
                let objCellTitle = tableView.dequeueReusableCell(withIdentifier: "OurTeamDetailTableViewCell") as! OurTeamDetailTableViewCell
                if let _ = self.objTeam{
                    objCellTitle.lblTitle.text = "\(objTeam!.userName)"
                    objCellTitle.lblPost.text = "\(objTeam!.userPost)"
                }
                return objCellTitle
            }else{
                let objCelDetail = tableView.dequeueReusableCell(withIdentifier: "AboutUsTableViewCell") as! AboutUsTableViewCell
                if let _ = self.objTeam{
                    objCelDetail.lblAboutUs.text = "\(self.objTeam!.userDescription)".replacingOccurrences(of: "\n", with: "\n\n")
                }
                return objCelDetail
            }
        }else{
            let objCell = tableView.dequeueReusableCell(withIdentifier: "AboutUsTableViewCell") as! AboutUsTableViewCell
            
            objCell.lblAboutUs.isUserInteractionEnabled = true
            objCell.lblAboutUs.tag = indexPath.row
            if indexPath.row == 2 || indexPath.row == 3{
                if indexPath.row == 2{
                    objCell.lblAboutUs.attributedText = self.getPrivacyPolicyAttributedText()
                }else{
                    objCell.lblAboutUs.attributedText = self.getYoutubeAttributedText()
                }
                let objGesture = UITapGestureRecognizer(target:self, action: #selector(tapLabel(gesture:)))
                objCell.lblAboutUs.addGestureRecognizer(objGesture)
            }else{
                objCell.lblAboutUs.text = self.arrayOfDetail[indexPath.row]
                
            }
            return objCell
        }
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func getPrivacyPolicyAttributedText()->NSMutableAttributedString{
        let text = "\(Vocabulary.shared.getWordFromKey(key: "checkout"))"
        let underlineAttriString = NSMutableAttributedString(string: text)
        let currentLan = String.getSelectedLanguage()
        let linkText = "\(currentLan == "1" ? "here":"隐私政策")" //"\(currentLan == "1" ? "here":"点此")" //隐私政策
        let range1 = (text as NSString).range(of:"\(linkText)")
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17.0), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:kThemeColor, range: range1)
       
        return underlineAttriString
    }
    func getYoutubeAttributedText()->NSMutableAttributedString{
        let text = "\(Vocabulary.shared.getWordFromKey(key: "youtube_channel"))"
        let underlineAttriString = NSMutableAttributedString(string: text)
        let currentLan = String.getSelectedLanguage()
        let linkText = "\(currentLan == "1" ? "here":"点此")"
        let range1 = (text as NSString).range(of:"\(linkText)")
        
        underlineAttriString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.font, value: UIFont.systemFont(ofSize: 17.0), range: range1)
        underlineAttriString.addAttribute(NSAttributedString.Key.foregroundColor, value:kThemeColor, range: range1)
        
        return underlineAttriString
    }
    @IBAction func tapLabel(gesture: UITapGestureRecognizer) {
        if let containerView = gesture.view{
            if containerView.tag == 2{ //privacy policy
                if let objViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebLoadViewController") as? WebLoadViewController{
                    objViewController.objURLString = "https://cdn.buttercms.com/qmzQOCNITrCh555uVdks"
                    objViewController.isBlog = true
                    self.navigationController?.pushViewController(objViewController, animated: true)
                }
            }else if containerView.tag == 3{ //youtube
                self.pushToYoutube()
                /*
                if UIApplication.shared.canOpenURL(URL.init(string: "https://www.youtube.com/channel/UCPmpxpJNXwSfgy7_z6ljKmg/featured")!){
                    DispatchQueue.main.async {
                        UIApplication.shared.open(URL.init(string: "https://www.youtube.com/channel/UCPmpxpJNXwSfgy7_z6ljKmg/featured")!, options: [:], completionHandler: nil)
                    }
                }*/
            }
        }
    }
    func pushToYoutube(){
        var objYoutubeURL = "https://www.youtube.com/channel/UC3MHpkVaHm6EsGunDg1xUpQ"
        
        var selectedLanguage = String.getSelectedLanguage()
        
        if selectedLanguage == "1" {
            objYoutubeURL = "https://www.youtube.com/channel/UC3MHpkVaHm6EsGunDg1xUpQ"
        } else if selectedLanguage == "2" {
            objYoutubeURL = "https://www.youtube.com/channel/UCPmpxpJNXwSfgy7_z6ljKmg"
        } else {
            objYoutubeURL = "https://www.youtube.com/channel/UC3MHpkVaHm6EsGunDg1xUpQ"
        }
        self.pushToYouTubeScreenWithURL(strURL: objYoutubeURL)
    }
    
}
