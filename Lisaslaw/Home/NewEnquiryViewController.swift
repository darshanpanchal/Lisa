//
//  NewEnquiryViewController.swift
//  Lisaslaw
//
//  Created by user on 18/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import MessageUI
class NewEnquiryViewController: UIViewController {

    @IBOutlet var lblTitle:UILabel!
    
    @IBOutlet var lblName:UILabel!
    @IBOutlet var lblEmail:UILabel!
    @IBOutlet var lblPhoneNumber:UILabel!
    @IBOutlet var lblDescription:UILabel!
    
    
    @IBOutlet var txtName:UITextField!
    @IBOutlet var txtEmail:UITextField!
    @IBOutlet var txtPhoneNumber:UITextField!
    
    @IBOutlet var txtDescription:UITextView!
    
    @IBOutlet var btnSubmit:UIButton!
    var emailDetail:[String:Any] = [:]
    
    @IBOutlet var tableView:UITableView!
    
    @IBOutlet var nameContainer:UIView!
    @IBOutlet var emailContainer:UIView!
    @IBOutlet var phoneContainer:UIView!
    @IBOutlet var detailContainer:UIView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblName.text = Vocabulary.shared.getWordFromKey(key:"name")
        self.lblEmail.text = Vocabulary.shared.getWordFromKey(key:"email_address")
        self.lblPhoneNumber.text = Vocabulary.shared.getWordFromKey(key:"phone number")
        self.lblDescription.text = Vocabulary.shared.getWordFromKey(key:"description")
        self.lblTitle.text = Vocabulary.shared.getWordFromKey(key:"new_enquiry")
        self.btnSubmit.setTitle(Vocabulary.shared.getWordFromKey(key:"submit"), for: .normal) 
        // Do any additional setup after loading the view.
        self.setUp()
    }
    func setUp(){
        self.txtName.delegate = self
        self.txtEmail.delegate = self
        self.txtPhoneNumber.delegate = self
        self.txtDescription.delegate = self
        self.tableView.tableFooterView = UIView()
    }
    // MARK: - Selector Methods
    @IBAction func buttonBackSelector(sender:UIButton){
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func buttonSubmitSelector(sender:UIButton){
        if self.isValid(){
            //self.sendEmail()
            self.sendEmailAPIRequest()
        }
    }
    // MARK: - Send Email API
    func sendEmailAPIRequest(){
        print(self.emailDetail)
        /*
         {"name": "test",
         "telephone": "2145285956",
         "emailAddress": "test@mailinator.com",
         "caseDescription": "",
         "emailSent": false,
         "error": false,
         "description": "ftesvjkvjvjhvjhhjcv"}
         */
        var sendEmailParameters:[String:Any] = [:]
        /*sendEmailParameters["error"] = "false"
        sendEmailParameters["emailSent"] = "false"
        sendEmailParameters["caseDescription"] = "" */
        sendEmailParameters["name"] = "\(self.emailDetail["name"] ?? "")"
        sendEmailParameters["telephone"] = "\(self.emailDetail["phonenumber"] ?? "")"
        sendEmailParameters["emailAddress"] = "\(self.emailDetail["email"] ?? "")"
        sendEmailParameters["description"] = "\(self.emailDetail["detail"] ?? "")"
        
        
        
        
        APIRequestClient.shared.sendRequest(requestType: .POST, queryString: kNewSendEmail, parameter:sendEmailParameters as! [String:AnyObject], isHudeShow: true, success: { (responseSuccess) in
            DispatchQueue.main.async {
                let currentLan = String.getSelectedLanguage()
                let linkText = "\(currentLan == "1" ? "Enquiry send successfully" : "成功递交")"
                ShowToast.show(toatMessage: "\(linkText)")
                self.navigationController?.popViewController(animated: true)
            }
        }) { (responseFail) in
            
            DispatchQueue.main.async {
                print(responseFail)
                ProgressHud.hide()
            }
        
            if let objFail = responseFail as? [String:Any],let message:String = objFail["message"] as? String{
                DispatchQueue.main.async {
                    ShowToast.show(toatMessage: "\(message)")
                }
            }
        }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    func isValid()->Bool{
        guard "\(self.emailDetail["name"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtName.invalideField()
                ShowToast.show(toatMessage: "\(Vocabulary.shared.getWordFromKey(key: "alert_name"))")
            }
            return false
        }
        guard "\(self.emailDetail["email"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtEmail.invalideField()
                ShowToast.show(toatMessage: "\(Vocabulary.shared.getWordFromKey(key: "alert_email"))")
            }
            return false
        }
        if let emailText:String = self.emailDetail["email"] as? String,!emailText.isValidEmail(){
            DispatchQueue.main.async {
                self.txtEmail.invalideField()
                ShowToast.show(toatMessage: "\(Vocabulary.shared.getWordFromKey(key: "alert_validemail"))")
            }
            return false
        }
        
        guard "\(self.emailDetail["phonenumber"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtPhoneNumber.invalideField()
                ShowToast.show(toatMessage: "\(Vocabulary.shared.getWordFromKey(key: "alert_validphonenumber"))")
            }
            return false
        }
        if let phoneText:String = self.emailDetail["phonenumber"] as? String,!self.isValidPhone(phone: phoneText){
            DispatchQueue.main.async {
                self.txtPhoneNumber.invalideField()
                ShowToast.show(toatMessage: "\(Vocabulary.shared.getWordFromKey(key: "alert_validphonenumber"))")
            }
            return false
        }
        guard "\(self.emailDetail["detail"] ?? "")".count > 0 else {
            DispatchQueue.main.async {
                self.txtDescription.invalideField()
                ShowToast.show(toatMessage: "\(Vocabulary.shared.getWordFromKey(key: "alert_description"))")
            }
            return false
        }
        
        self.txtName.validField()
        self.txtEmail.validField()
        self.txtPhoneNumber.validField()
        self.txtDescription.validField()
        
        return true
    }
    func isValidPhone(phone: String) -> Bool {
        let phoneRegex = "^[0-9+]{0,1}+[0-9]{5,16}$"
        let phoneTest = NSPredicate(format: "SELF MATCHES %@", phoneRegex)
        return phoneTest.evaluate(with: phone)
    }

}
extension NewEnquiryViewController:MFMailComposeViewControllerDelegate{
    func sendEmail(){
        
        if( MFMailComposeViewController.canSendMail() ) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients(["feedback@lisaslaw.co.uk"])//["info@lisaslaw.co.uk"])//["darshanp@itpathsolutions.in"])
            mailComposer.setSubject("New Enquiry - Lisa's Law")
            mailComposer.setMessageBody("\nName:\n\(self.emailDetail["name"]!) \n\n Email Address:\n\(self.emailDetail["email"]!)\n\nPhone Number:\n\(self.emailDetail["phonenumber"]!)\n\nPlease give a brief outline of your case and we will get back to you:\n\(self.emailDetail["detail"]!)", isHTML: false)
    
            
            self.present(mailComposer, animated: true, completion: {
                DispatchQueue.main.async {
                    ProgressHud.hide()
                }
            })
        }else{
            DispatchQueue.main.async {
                ProgressHud.hide()
            }
        }
        print("Email is not configured")
        
        
    }
    public func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?){
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
            self.navigationController?.popViewController(animated: false)
        }
        print("sent!")
    }
}
extension NewEnquiryViewController:UITextFieldDelegate{
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let typpedString = ((textField.text)! as NSString).replacingCharacters(in: range, with: string)
        if textField != self.txtName{
            guard !typpedString.isContainWhiteSpace() else{
                return false
            }
        }
        if textField == self.txtName{
            self.emailDetail["name"] = "\(typpedString)"
            self.txtName.validField()
        }else if textField == self.txtEmail{
            self.emailDetail["email"] = "\(typpedString)"
            self.txtEmail.validField()
        }else if textField == self.txtPhoneNumber{
            self.emailDetail["phonenumber"] = "\(typpedString)"
            self.txtPhoneNumber.validField()
        }else{
            
        }
        return true
    }
}
extension NewEnquiryViewController:UITextViewDelegate{
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        let typpedString = ((textView.text)! as NSString).replacingCharacters(in: range, with: text)
        
        if text == "\n"{
            textView.resignFirstResponder()
            return true
        }
         self.emailDetail["detail"] = "\(typpedString)"
        self.txtDescription.validField()
        return true
        
    }
}
