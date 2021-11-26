//
//  ViewController.swift
//  Lisaslaw
//
//  Created by user on 31/10/19.
//  Copyright © 2019 user. All rights reserved.
//

import UIKit
import MediaPlayer

class ViewController: UIViewController {

    @IBOutlet var objImageViewLogo:UIImageView!
    
    var player: AVPlayer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        //add fade animation on logo
        self.objImageViewLogo.alpha = 0
        self.configureFadeAnimation()
//        self.loadVideo()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        NotificationCenter.default.removeObserver(self)

    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
    }
    // MARK: - Custom Methods
    func configureFadeAnimation(){
        
        UIView.animate(withDuration: 4.0,
                       delay: 0,
                       options: [.curveEaseInOut],
                       animations: {
                        self.objImageViewLogo.alpha = 1
        },
                       completion: { _ in
                        //self.objImageViewLogo.alpha = 0
                        self.performSegue(withIdentifier: "pushToHome", sender: nil)
        })
    }
    private func loadVideo() {

        //this line is important to prevent background music stop
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .defaultToSpeaker) // setCategory(AVAudioSession.Category.ambient)
        } catch { }
        
        let path = Bundle.main.path(forResource: "test", ofType:"mp4")
        
        let filePathURL = NSURL.fileURL(withPath: path!)
        let player = AVPlayer(url: filePathURL)
        
        NotificationCenter.default.addObserver(self, selector: #selector(playerDidFinishPlaying), name: .AVPlayerItemDidPlayToEndTime, object: player.currentItem)

        
        let playerLayer = AVPlayerLayer(player: player)
        
        playerLayer.frame = CGRect.init(x: -(self.view.bounds.width/2), y: -(self.view.bounds.height/2), width: self.view.bounds.width*2, height: self.view.bounds.height*2)
        playerLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        playerLayer.zPosition = -1
        
        self.view.layer.addSublayer(playerLayer)
        player.seek(to: CMTime.zero)
        player.play()
    }
    @objc func playerDidFinishPlaying(note: NSNotification) {
//        ShowToast.show(toatMessage: "Video Finished")
        print("Video Finished")
        self.performSegue(withIdentifier: "pushToHome", sender: nil)
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

