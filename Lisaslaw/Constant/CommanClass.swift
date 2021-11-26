//
//  CommanClass.swift
//  Lisaslaw
//
//  Created by user on 04/11/19.
//  Copyright © 2019 user. All rights reserved.
//
import UIKit
import Foundation
import SDWebImage
import SystemConfiguration

class CommonClass: NSObject {
    
    //SingleTon
    static let shared:CommonClass = {
        let common = CommonClass()
        return common
    }()
    var isConnectedToInternet:Bool{
        get{
            var zeroAddress = sockaddr_in()
            zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
            zeroAddress.sin_family = sa_family_t(AF_INET)
            
            guard let defaultRouteReachability = withUnsafePointer(to: &zeroAddress, {
                $0.withMemoryRebound(to: sockaddr.self, capacity: 1) {
                    SCNetworkReachabilityCreateWithAddress(nil, $0)
                }
            }) else {
                return false
            }
            
            var flags: SCNetworkReachabilityFlags = []
            if !SCNetworkReachabilityGetFlags(defaultRouteReachability, &flags) {
                return false
            }
            
            let isReachable = flags.contains(.reachable)
            let needsConnection = flags.contains(.connectionRequired)
            return (isReachable && !needsConnection)
        }
    }
}


@IBDesignable
class ProgressHud: UIView {
    fileprivate static let rootView = {
        return UIApplication.shared.keyWindow!
    }()
    
    fileprivate static let blurView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.alpha = 0.2
        return view
    }()
    fileprivate static let hudView:UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = UIColor.clear
        view.layer.cornerRadius = 6.0
        view.clipsToBounds = true
        view.layoutIfNeeded()
        return view
    }()
    fileprivate static let gifImageView:UIImageView = {
       
        let imageData = try? Data(contentsOf: Bundle.main.url(forResource: "SASERP", withExtension: "gif")!)
        
        if let advTimeGif = UIImage.sd_image(withGIFData: imageData!){
            let objImage = UIImageView()
            objImage.image = advTimeGif
            objImage.contentMode = .scaleAspectFit
            objImage.translatesAutoresizingMaskIntoConstraints = false
            return objImage
        }
        return UIImageView()
        
    }()
    fileprivate static let activity:UIActivityIndicatorView = {
        let view = UIActivityIndicatorView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.startAnimating()
        view.style = .whiteLarge
        view.hidesWhenStopped = false
        view.color = UIColor.black
        
        return view
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    static func show(){
        rootView.addSubview(blurView)
        self.addObserver()
        self.addActivity()
    }
    static func addObserver(){
        NotificationCenter.default.addObserver(self, selector: #selector(rotated), name:UIDevice.orientationDidChangeNotification, object: nil)
    }
    @objc static func rotated(){
        print(UIScreen.main.bounds)
        switch UIDevice.current.orientation {
        case .landscapeLeft, .landscapeRight:
            print("landscape")
        default:
            print("Portrait")
        }
        blurView.frame = UIScreen.main.bounds
        //blurView.frame = CGRect.init(origin: .zero, size: CGSize.init(width: UIScreen.main.bounds.height, height: UIScreen.main.bounds.width))
        
    }
    static func addActivity(){
        rootView.addSubview(hudView)
        hudView.widthAnchor.constraint(equalToConstant: 125).isActive = true
        hudView.heightAnchor.constraint(equalToConstant: 125).isActive = true
        hudView.centerXAnchor.constraint(equalTo: hudView.superview!.centerXAnchor).isActive = true
        hudView.centerYAnchor.constraint(equalTo: hudView.superview!.centerYAnchor).isActive = true
        
        //        hudView.addSubview(activity)
        //        activity.centerXAnchor.constraint(equalTo: activity.superview!.centerXAnchor).isActive = true
        //        activity.centerYAnchor.constraint(equalTo: activity.superview!.centerYAnchor).isActive = true
        rootView.isUserInteractionEnabled = false
        
        hudView.addSubview(gifImageView)
        gifImageView.widthAnchor.constraint(equalToConstant: 50).isActive = true
        gifImageView.heightAnchor.constraint(equalToConstant: 50).isActive = true
        gifImageView.centerXAnchor.constraint(equalTo: gifImageView.superview!.centerXAnchor).isActive = true
        gifImageView.centerYAnchor.constraint(equalTo: gifImageView.superview!.centerYAnchor).isActive = true
        
        
    }
    static func hide(){
        
        DispatchQueue.main.async {
            NotificationCenter.default.removeObserver(self)
            rootView.isUserInteractionEnabled = true
            blurView.removeFromSuperview()
            hudView.removeFromSuperview()
        }
        
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
class ShowToast: NSObject {
    static var lastToastLabelReference:UILabel?
    static var initialYPos:CGFloat = 0
    class func show(toatMessage:String)
    {
        DispatchQueue.main.async {
            guard toatMessage != kCommonError else{
                
                return
            }
            if let app = UIApplication.shared.delegate as? AppDelegate, let keyWindow = app.window
            {
                ProgressHud.hide()
                if lastToastLabelReference != nil
                {
                    let prevMessage = lastToastLabelReference!.text?.replacingOccurrences(of: " ", with: "").lowercased()
                    let currentMessage = toatMessage.replacingOccurrences(of: " ", with: "").lowercased()
                    if prevMessage == currentMessage
                    {
                        return
                    }
                }
                
                let cornerRadious:CGFloat = 12
                let toastContainerView:UIView={
                    let view = UIView()
                    view.layer.cornerRadius = cornerRadious
                    view.translatesAutoresizingMaskIntoConstraints = false
                    view.backgroundColor = UIColor.init(hexString: "#808080")//UIColor.black//kSchoolThemeColor//UIColor.black.withAlphaComponent(0.8)
                    view.alpha = 1
                    return view
                }()
                let labelForMessage:UILabel={
                    let label = UILabel()
                    label.layer.cornerRadius = cornerRadious
                    label.layer.masksToBounds = true
                    label.textAlignment = .center
                    label.numberOfLines = 0
                    label.adjustsFontSizeToFitWidth = true
                    label.translatesAutoresizingMaskIntoConstraints = false
                    label.text = toatMessage
                    label.textColor = .white
                    label.backgroundColor = UIColor.init(white: 0, alpha: 0)
                    return label
                }()
                
                keyWindow.addSubview(toastContainerView)
                
                let fontType = UIFont.boldSystemFont(ofSize: DeviceType.isIpad() ? 14 : 12)
                labelForMessage.font = fontType
                
                let sizeOfMessage = NSString(string: toatMessage).boundingRect(with: CGSize(width: keyWindow.frame.width, height: keyWindow.frame.height), options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font:fontType], context: nil)
                
                let topAnchor = toastContainerView.bottomAnchor.constraint(equalTo: keyWindow.topAnchor, constant: 0)
                keyWindow.addConstraint(topAnchor)
                
                toastContainerView.centerXAnchor.constraint(equalTo: keyWindow.centerXAnchor, constant: 0).isActive = true
                
                var extraHeight:CGFloat = 0
                if (keyWindow.frame.size.width) < (sizeOfMessage.width+20)
                {
                    extraHeight = (sizeOfMessage.width+20) - (keyWindow.frame.size.width)
                    toastContainerView.leftAnchor.constraint(equalTo: keyWindow.leftAnchor, constant: 5).isActive = true
                    toastContainerView.rightAnchor.constraint(equalTo: keyWindow.rightAnchor, constant: -5).isActive = true
                }
                else
                {
                    toastContainerView.widthAnchor.constraint(equalToConstant: sizeOfMessage.width+20).isActive = true
                }
                let totolHeight:CGFloat = sizeOfMessage.height+25+extraHeight
                toastContainerView.heightAnchor.constraint(equalToConstant:totolHeight).isActive = true
                toastContainerView.addSubview(labelForMessage)
                lastToastLabelReference = labelForMessage
                labelForMessage.topAnchor.constraint(equalTo: toastContainerView.topAnchor, constant: 0).isActive = true
                labelForMessage.bottomAnchor.constraint(equalTo: toastContainerView.bottomAnchor, constant: 0).isActive = true
                labelForMessage.leftAnchor.constraint(equalTo: toastContainerView.leftAnchor, constant: 5).isActive = true
                labelForMessage.rightAnchor.constraint(equalTo: toastContainerView.rightAnchor, constant: -5).isActive = true
                keyWindow.layoutIfNeeded()
                
                let padding:CGFloat = initialYPos == 0 ? (DeviceType.isIpad() ? 100 : 70) : 10 // starting position
                initialYPos += padding+totolHeight
                topAnchor.constant = initialYPos
                
                UIView.animate(withDuration: 0.7, delay: 0, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.4, options: .curveEaseIn, animations: {
                    keyWindow.layoutIfNeeded()
                }, completion: { (bool) in
                    
                    topAnchor.constant = 0
                    UIView.animate(withDuration: 0.4, delay: 3, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveLinear, animations: {
                        keyWindow.layoutIfNeeded()
                    }, completion: { (bool) in
                        if let lastToastShown = lastToastLabelReference,labelForMessage == lastToastShown
                        {
                            lastToastLabelReference = nil
                        }
                        initialYPos -= (padding+totolHeight)
                        toastContainerView.removeFromSuperview()
                    })
                })
            }
        }
    }
}
extension UIColor {
    convenience init(hexString: String) {
        let hex = hexString.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int = UInt32()
        Scanner(string: hex).scanHexInt32(&int)
        let a, r, g, b: UInt32
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
}
class DeviceType{
    class func isIpad()->Bool{
        return UIDevice.current.userInterfaceIdiom == .pad ? true : false
    }
}

class Vocabulary:NSObject{
    static let shared:Vocabulary = Vocabulary()
    
    func getWordFromKey(key:String)->String{
        return getWordFromLocalPlist(key: key)//key.removeWhiteSpaces())
    }
    private func getWordFromLocalPlist(key:String)->String{
        
        var selectedLanguage = String.getSelectedLanguage()
        
        if selectedLanguage == "1" {
            selectedLanguage = "English"
        } else if selectedLanguage == "2" {
            selectedLanguage = "Chinese"
        } else {
            selectedLanguage = "English"
        }
        
        var vocabDictionary: NSDictionary?
        if let path = Bundle.main.path(forResource: selectedLanguage, ofType: "plist") {
            vocabDictionary = NSDictionary(contentsOfFile: path)
        }
        
        if let vocabsDictnary1 = vocabDictionary,let value = vocabsDictnary1[key] as? String{
            return value
        }
        return key.replacingOccurrences(of: "_", with: " ")
        
    }
    
}
extension String{
    func isValidEmail() -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: self)
    }
    func isContainWhiteSpace()->Bool{
        guard self.rangeOfCharacter(from: NSCharacterSet.whitespacesAndNewlines) == nil else{
            return true
        }
        return false
    }
    func removeWhiteSpaces()->String{
        return self.replacingOccurrences(of: " ", with: "")
    }
    static func getSelectedLanguage()->String{
        if let selection = UserDefaults.standard.value(forKey: "selectedLanguageCode") as? String{ // 1 eng , 2 china
            return selection.removeWhiteSpaces().lowercased()
        }
        return "1"
    }
    static func updateSelectedLanguage(){
        let updatedLanguage = (self.getSelectedLanguage() == "1") ? "2":"1"
        UserDefaults.standard.set("\(updatedLanguage)", forKey: "selectedLanguageCode")
        UserDefaults.standard.synchronize()
    }
}

class RoundedView: UIView {
    
    
    
    @IBInspectable var text:String = ""
    @IBInspectable var isBorder:Bool = false
    @IBInspectable var bordorColor:UIColor = .black
    @IBInspectable var borderWidth:CGFloat = 0.5
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        guard self.isBorder else {
            return
        }
       self.updateView()
    }
    func updateView(){
        for view in self.subviews{
            if view.tag == 100 || view.tag == 200{
                view.removeFromSuperview()
            }
        }
        let containerView = UIView.init(frame: CGRect.init(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        containerView.layer.borderWidth = self.borderWidth
        containerView.layer.borderColor = self.bordorColor.cgColor
        containerView.layer.cornerRadius = 6.0
        containerView.tag = 100
        self.addSubview(containerView)
        guard self.text.count > 0 else {
            return
        }
        let strMessage = " \(text) "
        let objFont = UIFont.systemFont(ofSize: 12.0)//UIFont.init(name: "OpenSans-Regular", size: 12.0)
        let fontAttributes = [NSAttributedString.Key.font: objFont]
        let size = strMessage.size(withAttributes: fontAttributes)
        
        let objLabel = UILabel.init(frame: CGRect.init(x: 10, y: -10, width: size.width, height: 20.0))
        objLabel.font = objFont
        objLabel.text = strMessage
        objLabel.backgroundColor = UIColor.white
        objLabel.textColor = UIColor.black
        objLabel.tag = 200
        self.addSubview(objLabel)
        
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
       
    }
}
extension UIView{
    func addShadow(color: UIColor, opacity: Float = 0.5, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true,cornerRadius:CGFloat) {
        let shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: cornerRadius).cgPath
        shadowLayer.fillColor = UIColor.clear.cgColor
        shadowLayer.shadowColor = color.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = offSet
        shadowLayer.shadowOpacity = 1.0//opacity
        shadowLayer.shadowRadius = radius
        layer.insertSublayer(shadowLayer, at: 0)
    }
    
    func dropShadow(color: UIColor, opacity: Float = 1.0, offSet: CGSize, radius: CGFloat = 1, scale: Bool = true) {
        
        layer.masksToBounds = false
        layer.shadowColor = color.cgColor
        layer.shadowOpacity = opacity
        layer.shadowOffset = offSet
        layer.shadowRadius = radius
        
        layer.shadowPath = UIBezierPath.init(rect: self.bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    func applyGradient(colours: [UIColor]) -> Void {
        self.applyGradient(colours: colours, locations:nil)
    }
    func applyGradient(colours: [UIColor], locations: [NSNumber]?) -> Void {
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func invalideField(){
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.05
        animation.repeatCount = 5
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: self.center.x - 4, y: self.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: self.center.x + 4, y: self.center.y))
        self.layer.add(animation, forKey: "position")
        self.setBorder(color: .red)
    }
    func setBorder(width:CGFloat = 0.4,color:UIColor){
        self.layer.masksToBounds = false
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }
    func validField(){
        self.setBorder(color: .clear)
    }
    func showMessageLabel(msg:String = Vocabulary.shared.getWordFromKey(key:"NoSearchResult"),backgroundColor:UIColor = UIColor.init(white:1, alpha: 1),headerHeight:CGFloat = 0.0){
        DispatchQueue.main.async {
            let label = UILabel()
            label.text = msg
            //            label.font = UIFont.italicSystemFont(ofSize: DeviceType.isIpad() ? 20 : 16)
            label.font = UIFont(name: "Avenir-Roman", size: 17.0)
            label.textColor = UIColor.black
            label.numberOfLines = 0
            label.tag = 851
            label.alpha = self.alpha
            label.backgroundColor = UIColor.clear
            label.textAlignment = .center
            for view in self.subviews{
                if view.tag == 851{
                    view.removeFromSuperview()
                }
            }
            self.addSubview(label)
            if let superView = self.superview{
                superView.layoutIfNeeded()
                
            }
            var lableY = self.bounds.origin.y
            if msg == Vocabulary.shared.getWordFromKey(key:"NoSearchResult"){
                lableY = (UIScreen.main.bounds.height > 568.0) ? self.bounds.origin.y+10.0 :  self.bounds.origin.y + 70.0
            }
            if headerHeight > 0.0{
                if self.bounds.height > headerHeight{
                    let objY =  (UIScreen.main.bounds.height > 568.0) ? headerHeight : 380.0
                    let heightOflbl = (UIScreen.main.bounds.height > 568.0) ? self.bounds.height-headerHeight : 60.0
                    label.frame = CGRect(x: self.bounds.origin.x, y: objY, width: self.bounds.width, height: heightOflbl)
                }
            }else{
                label.frame = CGRect(x: self.bounds.origin.x, y: lableY, width: self.bounds.width, height: self.bounds.height)
            }
            
            
        }
    }
    
    func removeMessageLabel(){
        DispatchQueue.main.async {
            for view in self.subviews{
                if view.tag == 851{
                    view.removeFromSuperview()
                }
            }
        }
    }
    func circularImg(imgWidth:CGFloat) {
        self.layer.cornerRadius = imgWidth / 2
        self.clipsToBounds = true
        //        self.layer.borderColor = UIColor.lightGray.cgColor
        //        self.layer.borderWidth = 1.5
    }
}
