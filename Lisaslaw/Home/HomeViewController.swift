//
//  HomeViewController.swift
//  Lisaslaw
//
//  Created by user on 31/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import MobileCoreServices
import CropViewController

class HomeViewController: UIViewController {

    @IBOutlet var languageButton:UIButton!
    
    @IBOutlet var tableViewHome:UITableView!
    lazy var selectedIndex:NSMutableSet = NSMutableSet()
    @IBOutlet var testImageView:UIImageView!
    lazy var objImagePickerController = UIImagePickerController()
    
    /*
    lazy var arrayOfSection = ["\(Vocabulary.shared.getWordFromKey(key: "social_media"))","\(Vocabulary.shared.getWordFromKey(key: "our_team"))","\(Vocabulary.shared.getWordFromKey(key:"contact_us"))","\(Vocabulary.shared.getWordFromKey(key: "about_us"))","\(Vocabulary.shared.getWordFromKey(key: "blog"))","\(Vocabulary.shared.getWordFromKey(key: "check_case"))","\(Vocabulary.shared.getWordFromKey(key: "scan_doc"))"]
 
    
    lazy var arrayOfSectionImages = ["social_media","our_team","contact_us","about_us","blog","connect_osprey","scan_doc"]
    */
    lazy var arrayOfSection = ["\(Vocabulary.shared.getWordFromKey(key: "new_enquiry"))","\(Vocabulary.shared.getWordFromKey(key: "check_case"))","\(Vocabulary.shared.getWordFromKey(key: "scan_doc"))","\(Vocabulary.shared.getWordFromKey(key:"contact_us"))",Vocabulary.shared.getWordFromKey(key: "about_us")]
    
    lazy var arrayOfSectionImages = ["new_enquiry","connect_osprey","scan_doc","contact_us","about_us"]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUp()
        //configure table view
        self.configureHomeTableView()
        // Do any additional setup after loading the view.
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
       
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
  
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeToPopDisable()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.swipeToPopEnable()
    }
    func swipeToPopEnable() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
    }
    func swipeToPopDisable() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    // MARK: - Selector Methods
    @IBAction func buttonfacebookselector(sender:UIButton){
       
    }
    @IBAction func buttonLanguageChangeSelector(sender:UIButton){
        let currentLan = String.getSelectedLanguage()
        let strAlertMessage = "Are you sure you want to change application language to \(currentLan == "1" ? "Chinese": "English") ?"
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "Change Language", message:"\(strAlertMessage)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "No", style: .cancel))
            let yesAction = UIAlertAction.init(title:"Yes", style: .default) { (_) in
                String.updateSelectedLanguage()
                self.setUp()
                
            }
            ac.addAction(yesAction)
            //ac.view.tintColor = kThemeColor
            self.tableViewHome.reloadData()
            self.present(ac, animated: true)
        }
    }
    // MARK: - Custom Methods
    func setUp(){
        DispatchQueue.main.async {
            self.languageButton.tintColor = kThemeLightColor
            let currentLan = String.getSelectedLanguage()
            self.languageButton.setTitle(" \(currentLan == "1" ? "中文": "English")", for: .normal)
            self.arrayOfSection = ["\(Vocabulary.shared.getWordFromKey(key: "new_enquiry"))","\(Vocabulary.shared.getWordFromKey(key: "check_case"))","\(Vocabulary.shared.getWordFromKey(key: "scan_doc"))","\(Vocabulary.shared.getWordFromKey(key:"contact_us"))",Vocabulary.shared.getWordFromKey(key: "about_us")]
            self.tableViewHome.reloadData()
        }
    }
    func configureHomeTableView(){
        self.tableViewHome.delegate = self
        self.tableViewHome.dataSource = self
        self.tableViewHome.reloadData()
        self.tableViewHome.separatorStyle = .none
        let objHeaderViewNIb = UINib.init(nibName:"HomeTableViewCell", bundle: nil)
        self.tableViewHome.register(objHeaderViewNIb, forCellReuseIdentifier: "HomeTableViewCell")
        self.tableViewHome.backgroundColor = UIColor.white
        let objContactUSNib = UINib.init(nibName: "ContactUSTableViewCell", bundle: nil)
        self.tableViewHome.register(objContactUSNib, forCellReuseIdentifier: "ContactUSTableViewCell")
        
    }
    
    // MARK: - Navigation
    func pushToWebURLLoadViewController(objStrURL:String,strTitle:String = ""){
        if let objViewController = self.storyboard?.instantiateViewController(withIdentifier: "WebLoadViewController") as? WebLoadViewController{
            objViewController.objURLString = objStrURL
            objViewController.strTitle = strTitle
            objViewController.isBlog = strTitle.count > 0
            self.navigationController?.pushViewController(objViewController, animated: true)
        }
    }
    func pushToOurTeamController(){
        if let ourTeamViewConroller = self.storyboard?.instantiateViewController(withIdentifier: "OurTeamViewController") as? OurTeamViewController{
            self.navigationController?.pushViewController(ourTeamViewConroller, animated: true)
        }
    }
    func pushToAboutUsViewController(){
        if let aboutUsViewController = self.storyboard?.instantiateViewController(withIdentifier: "AboutUsViewController") as? AboutUsViewController{
            aboutUsViewController.isOurTeam = false
            self.navigationController?.pushViewController(aboutUsViewController, animated: true)
        }
    }
    func pushToNewEnquiryController(){
        if let newEnquiry = self.storyboard?.instantiateViewController(withIdentifier: "NewEnquiryViewController") as? NewEnquiryViewController{
            self.navigationController?.pushViewController(newEnquiry, animated: true)
        }
    }
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}
extension HomeViewController:HomeTableViewContactUsDelegate{
    func loadUpdateWebURLSelector(strURL: String) {
        self.pushToWebURLLoadViewController(objStrURL: strURL)
    }
    func blogSelector(){
        let currentLan = String.getSelectedLanguage()
        if currentLan != "1"{
            self.pushToWebURLLoadViewController(objStrURL:kLisaBlogChiense,strTitle:"\(Vocabulary.shared.getWordFromKey(key: "blog"))")
        }else{
            self.pushToWebURLLoadViewController(objStrURL:kLisaBlog,strTitle:"\(Vocabulary.shared.getWordFromKey(key: "blog"))")

        }
    }
}
extension HomeViewController:HomeTableViewDelegate{
    func loadWebURLSelector(strURL: String) {
        self.pushToWebURLLoadViewController(objStrURL: strURL)
    }
    func loadWechatpopup() {
        if let countryPicker = self.storyboard?.instantiateViewController(withIdentifier: "WeChatPopupViewController") as? WeChatPopupViewController{
            countryPicker.modalPresentationStyle = .overCurrentContext
            self.navigationController?.present(countryPicker, animated: false, completion: nil)
        }
    }
}
extension HomeViewController:UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.arrayOfSection.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let objCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell") as! HomeTableViewCell
//        objCell.backgroundColor = .red
       objCell.lblName?.text = self.arrayOfSection[indexPath.row]
        objCell.subContainerView.isHidden = !self.selectedIndex.contains(indexPath.row)
        if indexPath.row == 1,self.selectedIndex.contains(indexPath.row){
            objCell.socialMediaContainer.isHidden = true
            objCell.contactUsContainer.isHidden = true
            objCell.connectToOspreyContainer.isHidden = false
        }else{
            objCell.socialMediaContainer.isHidden = true
            objCell.contactUsContainer.isHidden = true
            objCell.connectToOspreyContainer.isHidden = true
        }
        /*
        if indexPath.row == 0,self.selectedIndex.contains(indexPath.row) {
            objCell.socialMediaContainer.isHidden = false
            objCell.contactUsContainer.isHidden = true
            objCell.connectToOspreyContainer.isHidden = true
        }else if indexPath.row == 2,self.selectedIndex.contains(indexPath.row){
            objCell.socialMediaContainer.isHidden = true
            objCell.contactUsContainer.isHidden = false
            objCell.connectToOspreyContainer.isHidden = true
        }else if indexPath.row == 5,self.selectedIndex.contains(indexPath.row){
            objCell.socialMediaContainer.isHidden = true
            objCell.contactUsContainer.isHidden = true
            objCell.connectToOspreyContainer.isHidden = false
        }else{
            objCell.socialMediaContainer.isHidden = true
            objCell.contactUsContainer.isHidden = true
            objCell.connectToOspreyContainer.isHidden = true
        }*/
        objCell.delegate = self
        if self.arrayOfSectionImages.count > indexPath.row{
            objCell.buttonConnectToOsprey.addTarget(self, action: #selector(buttonConnectToOsprey(sender:)), for: .touchUpInside)
            if let objImage = UIImage.init(named: "\(self.arrayOfSectionImages[indexPath.row])"){
                objCell.iconImageView.image = objImage
            }else{
                objCell.iconImageView.image = nil
            }
        }
        objCell.setUp()
        if indexPath.row == 3 { //3 contact us
            let objUpdatedCell = tableView.dequeueReusableCell(withIdentifier: "ContactUSTableViewCell") as! ContactUSTableViewCell
            
            objUpdatedCell.contactusContainer.isHidden = !self.selectedIndex.contains(indexPath.row)
            if !self.selectedIndex.contains(indexPath.row){
                objUpdatedCell.imageRightDropArrow.image =  UIImage.init(named:"ic_arrow_right")
            }else{
                objUpdatedCell.imageRightDropArrow.image = UIImage.init(named:"ic_arrow_down")
            }
            
            objUpdatedCell.lblName?.text = self.arrayOfSection[indexPath.row]
            if let objImage = UIImage.init(named: "\(self.arrayOfSectionImages[indexPath.row])"){
                objUpdatedCell.iconImageView.image = objImage
            }else{
                objUpdatedCell.iconImageView.image = nil
            }
            DispatchQueue.main.async {
                objUpdatedCell.configureSelectedLanguage()
            }
            objUpdatedCell.delegate = self
            objUpdatedCell.callLocatization()
            return objUpdatedCell
        }else{
            return objCell
        }
        
    }
    @objc func buttonConnectToOsprey(sender:UIButton){
        self.pushToWebURLLoadViewController(objStrURL:kLisaConnectToOsprey,strTitle:" ")
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
        if self.selectedIndex.contains(indexPath.row){
            if indexPath.row == 0{ //social media
                return 150.0
            }else if indexPath.row == 2{//contact us
                return 260.0
            }else if indexPath.row == 3{//contact us
                return 450.0
            }else{//connect to osprey
                 return 290.0
            }
        }else{
            return 100.0
        }
    }
    func addRemoveAtIndexPath(indexPath:IndexPath){
        if self.selectedIndex.contains(indexPath.row){
            self.selectedIndex.remove(indexPath.row)
        }else{
            self.selectedIndex.add(indexPath.row)
        }
        DispatchQueue.main.async {
            self.tableViewHome.reloadData()
        }
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0{ //new enquiry
            self.pushToNewEnquiryController()
        }else if indexPath.row == 1 {// check your case || indexPath.row == 2{
             self.pushToWebURLLoadViewController(objStrURL:kLisaConnectToOsprey,strTitle:" ")
            //self.addRemoveAtIndexPath(indexPath: indexPath)
        }else if indexPath.row == 2{ //scan doc //our team
            if let scanView = self.storyboard?.instantiateViewController(withIdentifier: "ScanViewController") as? ScanViewController{
                scanView.strTitle = "\(Vocabulary.shared.getWordFromKey(key: "scan_doc"))"
                self.navigationController?.pushViewController(scanView, animated: true)
            }
            //self.pushToOurTeamController()
        }else if indexPath.row == 3{ //contact us //about us
            
            self.addRemoveAtIndexPath(indexPath: indexPath)
            //self.pushToAboutUsViewController()
        }else if indexPath.row == 4{ //about us  //blog
            self.pushToAboutUsViewController()
            //self.pushToWebURLLoadViewController(objStrURL:kLisaBlog,strTitle:"\(Vocabulary.shared.getWordFromKey(key: "blog"))")
        }else{
                
        }/*
        }else if indexPath.row == 5{ //connect to osprey
            if self.selectedIndex.contains(indexPath.row){
                self.selectedIndex.remove(indexPath.row)
            }else{
                self.selectedIndex.add(indexPath.row)
            }
            DispatchQueue.main.async {
                self.tableViewHome.reloadData()
            }
        }else{ //scan document
            if let scanView = self.storyboard?.instantiateViewController(withIdentifier: "ScanViewController") as? ScanViewController{
                scanView.strTitle = "\(Vocabulary.shared.getWordFromKey(key: "scan_doc"))"
                self.navigationController?.pushViewController(scanView, animated: true)
            }
            //self.scannerView()
        }*/
        
    }
    func scannerView(){
        DispatchQueue.main.async {
            self.objImagePickerController = UIImagePickerController()
            self.objImagePickerController.sourceType = .camera
            self.objImagePickerController.delegate = self
            self.objImagePickerController.allowsEditing = false
            self.objImagePickerController.showsCameraControls = true
            self.objImagePickerController.mediaTypes = [kUTTypeImage as String]
            self.view.endEditing(true)
            self.presentImagePickerController()
        }
    }
    func presentImagePickerController(){
        self.view.endEditing(true)
        self.present(self.objImagePickerController, animated: true, completion: nil)
    }
    func presentImageEditor(image:UIImage){
        let cropViewController = CropViewController(image: image)
        cropViewController.delegate = self
        self.present(cropViewController, animated: true, completion: nil)
    }
}
extension HomeViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: false, completion: nil)
            return
        }
        picker.dismiss(animated: true, completion: nil)
        self.presentImageEditor(image: originalImage)
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Save error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
extension HomeViewController:CropViewControllerDelegate{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        cropViewController.dismiss(animated: true, completion: nil)
        self.testImageView.image = image
        self.navigationController?.pushViewController(ScanViewController(), animated: true)
    }
}
extension Int {
    var isPrimeNumber:Bool{
        return (self > 1) && !(2..<self).contains{self % $0 == 0}
    }
    var isPrime: Bool {
        guard self >= 2     else { return false }
        guard self != 2     else { return true  }
        guard self % 2 != 0 else { return false }
        return !stride(from: 3, through: Int(sqrt(Double(self))), by: 2).contains { self % $0 == 0 }
    }
   
}
extension HomeViewController:UIGestureRecognizerDelegate{
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
