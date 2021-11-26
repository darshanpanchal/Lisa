//
//  OurTeamViewController.swift
//  Lisaslaw
//
//  Created by user on 07/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class OurTeamViewController: UIViewController {

    @IBOutlet var lblTitle:UILabel!
    
    lazy var arrayOfTeam:[OurTeamModel] = []
    
    lazy var arrayOfImageName:[String] = ["team","team","team","team","team","team","team","team","team","team",
                                         "team","team","team","team","team","team","team","team","team","team",
                                         "team","team","team","team","team","team","team","team","team","team"]
    
    
    
    
    lazy var arrayName:[String] = [
        "\(Vocabulary.shared.getWordFromKey(key: "chuanli_ding"))",
        "\(Vocabulary.shared.getWordFromKey(key: "eli_lee"))",
        "\(Vocabulary.shared.getWordFromKey(key: "felix_otouke"))",
        "\(Vocabulary.shared.getWordFromKey(key: "bhavini_bhatt"))",
        "\(Vocabulary.shared.getWordFromKey(key: "ellen_hall"))",
        "\(Vocabulary.shared.getWordFromKey(key: "mingyan_gao"))",
        "\(Vocabulary.shared.getWordFromKey(key: "salina_lim"))",
        "\(Vocabulary.shared.getWordFromKey(key: "lavinder_kaur"))",
        "\(Vocabulary.shared.getWordFromKey(key: "serena_qin"))",
        "\(Vocabulary.shared.getWordFromKey(key: "caryn_toh"))",
        "\(Vocabulary.shared.getWordFromKey(key: "kevin_wong"))",
        "\(Vocabulary.shared.getWordFromKey(key: "binger_chen"))",
        "\(Vocabulary.shared.getWordFromKey(key: "yitong_guo"))",
        "\(Vocabulary.shared.getWordFromKey(key: "mandy_ma"))",
        "\(Vocabulary.shared.getWordFromKey(key: "renaldoda_costa"))",
        "\(Vocabulary.shared.getWordFromKey(key: "daysi_munoz_ortega"))",
        "\(Vocabulary.shared.getWordFromKey(key: "jessie_chow"))",
        "\(Vocabulary.shared.getWordFromKey(key: "michaet_hsieh"))",
        "\(Vocabulary.shared.getWordFromKey(key: "stephanie_chiu"))",
        "\(Vocabulary.shared.getWordFromKey(key: "sabrina_yuan"))",
        "\(Vocabulary.shared.getWordFromKey(key: "stephanie_shi"))",
        "\(Vocabulary.shared.getWordFromKey(key: "veasta_li"))",
        "\(Vocabulary.shared.getWordFromKey(key: "surveyn_hoh"))",
        "\(Vocabulary.shared.getWordFromKey(key: "jessica_luo"))",
        "\(Vocabulary.shared.getWordFromKey(key: "shanshan_chen"))",
        "\(Vocabulary.shared.getWordFromKey(key: "leanne_zhu_zhou"))",
        "\(Vocabulary.shared.getWordFromKey(key: "mandy_chiangn"))",
        
        
        
        ]
    
    
    
    
    
    
    lazy var arrayPost:[String] = [
        "\(Vocabulary.shared.getWordFromKey(key: "manager_director"))",
        "\(Vocabulary.shared.getWordFromKey(key: "company_director"))",
        "\(Vocabulary.shared.getWordFromKey(key: "company_director_solicitor"))",
        "\(Vocabulary.shared.getWordFromKey(key: "bhavini_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "ellen_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "solicitor"))",
        "\(Vocabulary.shared.getWordFromKey(key: "salina_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "solicitor"))",//"\(Vocabulary.shared.getWordFromKey(key: "lavinder_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "serena_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "caryn_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "trainee_solicitor"))",
        "\(Vocabulary.shared.getWordFromKey(key: "binger_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "trainee_solicitor"))",
        "\(Vocabulary.shared.getWordFromKey(key: "mandy_ma_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "renaldoda_costa_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "daysi_munoz_ortega_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "paralegal"))",
        "\(Vocabulary.shared.getWordFromKey(key: "michaet_hsieh_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "stephanie_chiu_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "legal_assistant"))",
        "\(Vocabulary.shared.getWordFromKey(key: "legal_assistant"))",
        "\(Vocabulary.shared.getWordFromKey(key: "legal_assistant"))",
        "\(Vocabulary.shared.getWordFromKey(key: "surveyn_hoh_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "jessica_luo_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "shanshan_chen_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "leanne_zhu_zhou_post"))",
        "\(Vocabulary.shared.getWordFromKey(key: "mandy_chiangn_post"))",
        ]
    
    
    
    
    
    lazy var arrayOfDescription:[String] = ["\(Vocabulary.shared.getWordFromKey(key: "chuanli_detail"))",
                                           "\(Vocabulary.shared.getWordFromKey(key: "elin_detail"))",
                                           "\(Vocabulary.shared.getWordFromKey(key: "felix_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "bhavini_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "ellen_details"))",
                                           "\(Vocabulary.shared.getWordFromKey(key: "mingyan_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "salina_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "lavinder_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "serena_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "caryn_detais"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "kevin_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "binger_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "yitong_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "mandy_ma_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "renaldoda_costa_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "daysi_munoz_ortega_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "jessie_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "michaet_hsieh_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "stephanie_chiu_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "sabrina_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "stephanie_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "veasta_detail"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "surveyn_hoh_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "jessica_luo_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "shanshan_chen_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "leanne_zhu_zhou_details"))",
                                            "\(Vocabulary.shared.getWordFromKey(key: "mandy_chiangn_details"))",
        
                                            ]
    
    
    
      
    
    @IBOutlet var buttonBack:UIButton!
    
    @IBOutlet var tableViewOurTeam:UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblTitle.text = Vocabulary.shared.getWordFromKey(key: "our_team")
        self.lblTitle.textColor = UIColor.black
        // Do any additional setup after loading the view.
        //configure back button
        self.configureButtonBack()
        //Configure TableView
        self.configureTableView()
    }
    
    // MARK: - Custom Methods
    func configureButtonBack(){
        
    }
    func configureTableView(){
        let objNib = UINib.init(nibName: "OurTeamTableViewCell", bundle: nil)
        self.tableViewOurTeam.register(objNib, forCellReuseIdentifier: "OurTeamTableViewCell")
        self.tableViewOurTeam.delegate = self
        self.tableViewOurTeam.dataSource = self
        self.tableViewOurTeam.reloadData()
        self.tableViewOurTeam.separatorStyle = .none
        
        
        self.arrayOfTeam.removeAll()
        for i:Int in 0..<self.arrayName.count{
            print("team\(i)")
            let objTeam = OurTeamModel.init(id:"\(i)",imageName:"team\(i)", userName: self.arrayName[i], userPost: self.arrayPost[i], userDescription:self.arrayOfDescription[i])
            self.arrayOfTeam.append(objTeam)
            
        }
        
    }
    // MARK: - Selector Methods
    @IBAction func buttonBackSelector(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
extension OurTeamViewController:UITableViewDelegate,UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfTeam.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objCell = tableView.dequeueReusableCell(withIdentifier: "OurTeamTableViewCell") as! OurTeamTableViewCell
        if self.arrayOfTeam.count > 0{
            let objTeam = self.arrayOfTeam[indexPath.row]
                if objTeam.userName.count > 0{
                    objCell.lblTeamName.text = objTeam.userName
                }else{
                    objCell.lblTeamName.text = ""
                }
                if objTeam.userPost.count > 0{
                    objCell.lblPost.text = objTeam.userPost
                }else{
                    objCell.lblPost.text = ""
                }
                if objTeam.imageName.count > 0{
                    if let objImage = UIImage.init(named:objTeam.imageName){
                        objCell.imgTeam.image = objImage
                    }else{
                        objCell.imgTeam.image = nil
                    }
                }
                if objTeam.userDescription.count > 0{
                    objCell.lblDescription.text = objTeam.userDescription
                }else{
                    objCell.lblDescription.text = ""
                }
            objCell.buttonReadMore.tag = indexPath.row
            objCell.buttonReadMore.addTarget(self, action: #selector(buttonReadMore(sender:)), for:.touchUpInside)
        }
        
        return objCell
    }
    @objc func buttonReadMore(sender:UIButton){
        if self.arrayOfTeam.count > sender.tag{
            self.pushToTeamDetail(objTeam: self.arrayOfTeam[sender.tag])
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return tableView.bounds.height/2
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.arrayOfTeam.count > indexPath.row{
            //self.pushToTeamDetail(objTeam: self.arrayOfTeam[indexPath.row])
        }
    }
    func pushToTeamDetail(objTeam:OurTeamModel){
        if let objTeamDetailViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController{
            objTeamDetailViewController.isOurTeam = true
            objTeamDetailViewController.objTeam = objTeam
            self.navigationController?.pushViewController(objTeamDetailViewController, animated: true)
        }
    }
}
struct OurTeamModel {
    var id:String = ""
    var imageName:String = ""
    var userName:String = ""
    var userPost:String = ""
    var userDescription:String = ""
}
