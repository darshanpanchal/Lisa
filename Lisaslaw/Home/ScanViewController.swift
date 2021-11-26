//
//  ScanViewController.swift
//  Lisaslaw
//
//  Created by user on 04/11/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import PDFGenerator
import MessageUI
import MobileCoreServices
import CropViewController
import QuickLook

class ScanViewController: UIViewController {
    
    @IBOutlet var navigationTitleImage:UIImageView!
    @IBOutlet var lblTitle:UILabel!
    
    @IBOutlet var lblEmptyHint1:UILabel!
    @IBOutlet var lblEmptyHint2:UILabel!
    @IBOutlet var lblEmptyHint3:UILabel!
    
    
    @IBOutlet var lblEmptyHint:UILabel!
    
    
    @IBOutlet var buttonPDF:UIButton!
    @IBOutlet var buttonBack:UIButton!
    @IBOutlet var buttonAdd:UIButton!
    
    @IBOutlet var collectionViewImages:UICollectionView!
    
    @IBOutlet var imageViewRigh:UIImageView!
    
    var previewItem:NSURL?
    var textField: UITextField?
    var emailSubject:String = ""
    
    lazy var arrayOfImages:[UIImage] = []
    lazy var strTitle:String = ""
    lazy var objImagePickerController = UIImagePickerController()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.lblEmptyHint.text = Vocabulary.shared.getWordFromKey(key:"click_to_scan")
        self.lblEmptyHint1.text = Vocabulary.shared.getWordFromKey(key:"scan_hint1")
        self.lblEmptyHint2.text = Vocabulary.shared.getWordFromKey(key:"scan_hint2")
        self.lblEmptyHint3.text = Vocabulary.shared.getWordFromKey(key:"scan_hint3")
        
        if self.strTitle.count > 0{
            self.navigationTitleImage.isHidden = true
            self.lblTitle.text = self.strTitle
        }else{
            self.navigationTitleImage.isHidden = false
        }
        
        //configure collection view
        self.configureCollectionView()
        
//        self.arrayOfImages.append(UIImage.init(named: "facebook")!)
//        self.collectionViewImages.reloadData()
        self.imageViewRigh.transform = CGAffineTransform(rotationAngle: .pi/5)
     
    }
    // MARK: - Custom Methods
    func configurationTextField(textField: UITextField!) {
        if (textField) != nil {
            self.textField = textField!        //Save reference to the UITextField
            let placeHolder = "\(Vocabulary.shared.getWordFromKey(key: "email_alert_placeholder"))"
            self.textField?.placeholder = placeHolder//"Enter Your Name or Case Number"
        }
    }

    func openAlertView() {
        let alertMessage = "\(Vocabulary.shared.getWordFromKey(key: "email_alert_message"))"
        let alert = UIAlertController(title: "", message: alertMessage, preferredStyle: UIAlertController.Style.alert)
        alert.addTextField(configurationHandler: configurationTextField)
        let okayText = "\(Vocabulary.shared.getWordFromKey(key:"continue"))"
        let cancelText = "\(Vocabulary.shared.getWordFromKey(key:"cancel"))"
        alert.addAction(UIAlertAction(title: cancelText, style: .cancel, handler:nil))
        alert.addAction(UIAlertAction(title: okayText, style: .default, handler:{ (UIAlertAction) in
            if let typpedString = self.textField?.text{
                self.emailSubject = typpedString
                self.sendEmail()
            }else{
                self.emailSubject = ""
            }
        }))
        self.present(alert, animated: true, completion: nil)
    }
    func configureCollectionView(){
        let objNIb = UINib.init(nibName: "ScanCollectionViewCell", bundle: nil)
        self.collectionViewImages.register(objNIb, forCellWithReuseIdentifier: "ScanCollectionViewCell")
        self.collectionViewImages.delegate = self
        self.collectionViewImages.dataSource = self
        self.collectionViewImages.reloadData()
    }
    func generatePDF(isPreview:Bool = false) {
        let viewHeight = UIScreen.main.bounds.width*1.41
        
        var pages:[PDFPage] = []
        
        for image:UIImage in self.arrayOfImages{
            let v1 = UIView(frame: CGRect(x: 0.0,y: 0, width: UIScreen.main.bounds.width, height:viewHeight))
       
            v1.backgroundColor = .white
            let imageFrame = CGRect.init(x: 10, y: 10.0, width: UIScreen.main.bounds.width-20, height:viewHeight-20.0)
            let objImageView = UIImageView.init(frame: imageFrame)
            objImageView.image = image
            objImageView.contentMode = .scaleAspectFit
            objImageView.clipsToBounds = true
            v1.addSubview(objImageView)
            pages.append(PDFPage.view(v1))
        }
  
        let pdfURL = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last! as URL

        let dst = pdfURL.appendingPathComponent("MyFile.pdf")//NSTemporaryDirectory().appending("sample1.pdf")
        
        do {
            try PDFGenerator.generate(pages, to: dst)
            if isPreview{
                self.previewItem = dst as NSURL
                self.pdfPreviewSelector()
               
            }else{
                let fileData = try Data.init(contentsOf: dst)//NSData(contentsOfFile: dst.absoluteString){
                self.sendEmail(data: fileData as Data)
               
            }
          
        } catch (let e) {
            print(e)
            DispatchQueue.main.async {
                ProgressHud.hide()
            }
        }
    }
    func configureBackAlert(){
        DispatchQueue.main.async {
            let ac = UIAlertController(title: "\(Vocabulary.shared.getWordFromKey(key: "alert"))", message:"\(Vocabulary.shared.getWordFromKey(key: "scan_back_alert"))", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "\(Vocabulary.shared.getWordFromKey(key: "no"))", style: .default))
            let yesAction = UIAlertAction.init(title:"\(Vocabulary.shared.getWordFromKey(key: "yes"))", style: .cancel) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            ac.addAction(yesAction)
//            ac.view.tintColor = kThemeColor
            self.present(ac, animated: true)
        }
    }
    func scannerView(){
        DispatchQueue.main.async {
            self.objImagePickerController = UIImagePickerController()
            self.objImagePickerController.sourceType = .camera
            self.objImagePickerController.delegate = self
          
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
        cropViewController.aspectRatioPickerButtonHidden = true
        cropViewController.rotateButtonsHidden = true
        cropViewController.rotateClockwiseButtonHidden = true
        cropViewController.doneButtonTitle = "\(Vocabulary.shared.getWordFromKey(key: "done"))"
        cropViewController.cancelButtonTitle = "\(Vocabulary.shared.getWordFromKey(key: "cancel"))"
        self.present(cropViewController, animated: true, completion: nil)
    }
    // MARK: - Selector Methods
    @IBAction func buttonPDFSelector(sender:UIButton){
        if self.arrayOfImages.count > 0 {
            self.openAlertView()
        }else{
            ShowToast.show(toatMessage: Vocabulary.shared.getWordFromKey(key: "scanner_validation"))
        }
       
        
    }
    func sendEmail(){
        DispatchQueue.main.async {
            ProgressHud.show()
            self.generatePDF()
        }
    }
    @IBAction func buttonBackSelector(sender:UIButton){
        if self.arrayOfImages.count > 0{
            self.configureBackAlert()
        }else{
           self.navigationController?.popViewController(animated: true)

        }
    }
    @IBAction func buttonPDFPreviewSelector(sender:UIButton){
        DispatchQueue.main.async {
            if self.arrayOfImages.count > 0 {
                if let _ = self.previewItem{
                    self.pdfPreviewSelector()
                }else{
                    ProgressHud.show()
                    self.generatePDF(isPreview: true)
                }
                
            }else{
                
                ShowToast.show(toatMessage: Vocabulary.shared.getWordFromKey(key:"scanner_validation"))
            }
        }
    }
    func pdfPreviewSelector(){
        DispatchQueue.main.async {
            ProgressHud.hide()
            let previewController = QLPreviewController()
            previewController.dataSource = self
            previewController.delegate = self
            previewController.currentPreviewItemIndex = 0
            self.present(previewController, animated: true, completion: nil)
        }
    }
    @IBAction func buttonAddSelector(sender:UIButton){
        //PresentMedia Selector
        let actionSheetController = UIAlertController.init(title: "", message:"\(Vocabulary.shared.getWordFromKey(key: "scan_image"))", preferredStyle: .actionSheet)
        let cancelSelector = UIAlertAction.init(title: "\(Vocabulary.shared.getWordFromKey(key: "cancel"))", style: .cancel, handler:nil)
        actionSheetController.addAction(cancelSelector)
        
        let cameraSelector = UIAlertAction.init(title: "\(Vocabulary.shared.getWordFromKey(key: "camera"))", style: .default) { (_) in

            DispatchQueue.main.async {
                self.objImagePickerController = UIImagePickerController()
                self.objImagePickerController.sourceType = .camera
                self.objImagePickerController.delegate = self
                self.objImagePickerController.allowsEditing = false
                self.objImagePickerController.mediaTypes = [kUTTypeImage as String]
                self.view.endEditing(true)
                self.presentImagePickerController()
            }
        }
        actionSheetController.addAction(cameraSelector)
        
        let photosSelector = UIAlertAction.init(title: "\(Vocabulary.shared.getWordFromKey(key: "photos"))", style: .default) { (_) in
            DispatchQueue.main.async {
                 self.objImagePickerController = UIImagePickerController()
                 self.objImagePickerController.sourceType = .savedPhotosAlbum
                 self.objImagePickerController.delegate = self
                 self.objImagePickerController.allowsEditing = false
                 self.objImagePickerController.mediaTypes = [kUTTypeImage as String]
                 self.view.endEditing(true)
                 self.presentImagePickerController()
                
            }
        }
        actionSheetController.addAction(photosSelector)
        self.view.endEditing(true)
//        actionSheetController.view.tintColor = kThemeColor
        if let popoverController = actionSheetController.popoverPresentationController {
            popoverController.sourceRect = self.buttonAdd.bounds
            popoverController.sourceView = self.buttonAdd
            
        }
        self.present(actionSheetController, animated: true, completion: nil)
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
extension ScanViewController:MFMailComposeViewControllerDelegate{
    func sendEmail(data:Data){
        if( MFMailComposeViewController.canSendMail() ) {
            let mailComposer = MFMailComposeViewController()
            mailComposer.mailComposeDelegate = self
            
            mailComposer.setToRecipients(["documents@lisaslaw.co.uk"])//["darshanp@itpathsolutions.in"])
            mailComposer.setSubject("\(emailSubject)")
            //mailComposer.setMessageBody("My body message", isHTML: true)
            mailComposer.addAttachmentData(data, mimeType: "application/pdf", fileName: "MyFile.pdf")
           
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
            self.arrayOfImages.removeAll()
            self.collectionViewImages.reloadData()
            self.navigationController?.popViewController(animated: false)

        }
        print("sent!")
    }
}
extension ScanViewController:UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        self.collectionViewImages.isHidden = !(self.arrayOfImages.count > 0)
        return self.arrayOfImages.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let scanImageCell:ScanCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "ScanCollectionViewCell", for: indexPath) as! ScanCollectionViewCell
        scanImageCell.imageView.image = self.arrayOfImages[indexPath.row]
        
        return scanImageCell
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize{
        if DeviceType.isIpad(){
            return CGSize.init(width: UIScreen.main.bounds.width/3, height: UIScreen.main.bounds.width/3)
        }else{
            return CGSize.init(width: UIScreen.main.bounds.width/2, height: UIScreen.main.bounds.width/2)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        return CGSize.init(width: collectionView.bounds.width, height: 85.0)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets{
        return UIEdgeInsets.zero
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat{
        return 0
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if self.arrayOfImages.count > indexPath.row{
            
        }
    }
}
extension ScanViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            return
        }
        /*
        guard let editImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            dismiss(animated: true, completion: nil)
            self.updateCollection(image: originalImage)
            return
        }*/
        picker.dismiss(animated: true, completion: nil)
        self.previewItem = nil
        if let imageData = originalImage.jpeg(.lowest) {
            if let image = UIImage.init(data: imageData){
                self.arrayOfImages.append(image)
            }else{
                self.arrayOfImages.append(originalImage)
            }
        }else{
            self.arrayOfImages.append(originalImage)
        }

        DispatchQueue.main.async {
            self.collectionViewImages.reloadData()
        }
        //self.presentImageEditor(image: originalImage)
    }
    func updateCollection(image:UIImage){
        self.previewItem = nil
        self.arrayOfImages.append(image)
        DispatchQueue.main.async {
            self.collectionViewImages.reloadData()
        }
    }
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // we got back an error!
            let ac = UIAlertController(title: "Scan error", message: error.localizedDescription, preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "OK", style: .default))
            present(ac, animated: true)
        } else {
            let ac = UIAlertController(title: "Saved!", message: "Your altered image has been saved to your photos.", preferredStyle: .alert)
            let _ = UIAlertAction.init(title:"Yes", style: .cancel) { (_) in
                self.navigationController?.popViewController(animated: true)
            }
            ac.addAction(UIAlertAction(title: "No", style: .default))
            //present(ac, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        
        picker.dismiss(animated: true, completion: nil)
        
    }
}
extension ScanViewController:CropViewControllerDelegate{
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        // 'image' is the newly cropped version of the original image
        /*
        cropViewController.dismiss(animated: true, completion: nil)
        
        self.previewItem = nil
        self.arrayOfImages.append(image)
        DispatchQueue.main.async {
            self.collectionViewImages.reloadData()
        }*/
    }
}
extension ScanViewController:QLPreviewControllerDataSource,QLPreviewControllerDelegate{
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
        return 1
    }
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
        if let _ = previewItem{
            return self.previewItem!
        }else{
            return URL.init(fileURLWithPath:"") as QLPreviewItem
        }
        
    }
    
}
extension UIImage {
    enum JPEGQuality: CGFloat {
        case lowest  = 0
        case low     = 0.25
        case lowMedium = 0.35
        case medium  = 0.5
        case high    = 0.75
        case highest = 1
    }

    /// Returns the data for the specified image in JPEG format.
    /// If the image object’s underlying image data has been purged, calling this function forces that data to be reloaded into memory.
    /// - returns: A data object containing the JPEG data, or nil if there was a problem generating the data. This function may return nil if the image has no data or if the underlying CGImageRef contains data in an unsupported bitmap format.
    func jpeg(_ jpegQuality: JPEGQuality) -> Data? {
        return jpegData(compressionQuality: jpegQuality.rawValue)
    }
}
