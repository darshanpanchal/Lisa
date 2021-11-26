//
//  WeChatPopupViewController.swift
//  Lisaslaw
//
//  Created by user on 19/12/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit

class WeChatPopupViewController: UIViewController {

    @IBOutlet var containerView:UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.containerView.clipsToBounds = true
        self.containerView.layer.cornerRadius = 6.0
    }
    @IBAction func buttonFullSelector(sender:UIButton){
        self.dismiss(animated: false, completion: nil)
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
