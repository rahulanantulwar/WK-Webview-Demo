//
//  ViewControllerForAppearence.swift
//  MockupWKWebkit
//
//  Created by Rahul Anantulwar on 9/26/18.
//  Copyright © 2018 Rahul Anantulwar. All rights reserved.
//

import UIKit
import AVFoundation
import AVKit

class ViewControllerForAppearence: UIViewController {

   
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet var timeSlider: UISlider!
    @IBOutlet var currentTimeLabel: UILabel!
    @IBOutlet var durationLabel: UILabel!
    @IBOutlet var volumeSlider: UISlider!
    
    // getting player to play the video
    var player: AVPlayer? = nil
    var playerLayer: AVPlayerLayer!
    var isVideoPlaying: Bool = false
    var isMute = false
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        guard  let path = Bundle.main.path(forResource: "IMG", ofType: "MOV") else {
//            print("Something is wrong in fetchinf video")
//            return
//        }
//
//        // setting the video URL
//        //let videoURL = URL(fileURLWithPath: path)
//
//        // setting player into view call AVPlayerViewController
////        let playerViewController = AVPlayerViewController()
////        playerViewController.player = player
////        self.present(playerViewController, animated: true){
////            playerViewController.player?.play()
////        }
//        let videoURL =  URL(string: "https://aao-cali-s3.s3.amazonaws.com/AAO.production/inputs/e6b2a04b-0c62-4eda-b8b5-52d3a64f590c/PEDIG.mp4")
//        // getting player to play the video
//        let player = AVPlayer(url: videoURL!)
//        let playerLayer = AVPlayerLayer(player: player)
//        playerLayer.frame = self.view.bounds
//        self.playerView.layer.addSublayer(playerLayer)
//        player.play()
//
//        //self.view.layer.addSublayer(playerViewController)
//        //self.imageView.layer.addSublayer(player)
//    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

                // Do any additional setup after loading the view.
                let videoURL =  URL(string: "https://aao-cali-s3.s3.amazonaws.com/AAO.production/inputs/e6b2a04b-0c62-4eda-b8b5-52d3a64f590c/PEDIG.mp4")
        
                // getting player to play the video
                // functionality check for local video
                /*
                guard let path = Bundle.main.path(forResource: "IMG", ofType: "MOV") else {return}
                let videoURL = URL(fileURLWithPath: path)
                */
        
                player = AVPlayer(url: videoURL!)
                playerLayer = AVPlayerLayer(player: player)
                player?.currentItem?.addObserver(self, forKeyPath: "duration", options: [.new, .initial], context: nil)
                addTimeObserver()
        
                self.playerView.layer.addSublayer(playerLayer)
                playerView.layer.cornerRadius = 10
                playerLayer.videoGravity = .resize
        
                playerLayer.masksToBounds = true
                playerLayer.cornerRadius = 10
        
                self.willGestureActivate()
                //player.play()
        
                //self.view.layer.addSublayer(playerViewController)
                //self.imageView.layer.addSublayer(player)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        playerLayer.frame = playerView.bounds
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func willGoToWebView(_ sender: UIButton) {
        performSegue(withIdentifier: "SegueForWebView", sender: self)
    }
    
    @IBAction func playVideo(_ sender: UIButton) {
        
        if isVideoPlaying {
            player?.pause()
            isVideoPlaying = false
            sender.setTitle("Play", for: .normal)
        } else {
            player?.play()
            isVideoPlaying = true
            sender.setTitle("Pause", for: .normal)
        }
    }
    
    @IBAction func forward(_ sender: UIButton) {
        guard let duration = player?.currentItem?.duration else{return}
        
        let currentTime = CMTimeGetSeconds((player?.currentTime())!)
        print("current time = \(currentTime)")
        let newTime = currentTime + 5.0
        if newTime < (CMTimeGetSeconds(duration) - 5.0) {
            let time: CMTime = CMTimeMake(Int64(newTime*1000), 1000)
            player?.seek(to: time)
        }
    }
    
    @IBAction func backward(_ sender: UIButton) {
         let currentTime = CMTimeGetSeconds((player?.currentTime())!)
        print("current time = \(currentTime)")
        var newTime = currentTime - 5.0
        if newTime < 0 {
            newTime = 0
        }
        let time: CMTime = CMTimeMake(Int64(newTime*1000), 1000)
        player?.seek(to: time)
    }
    
    
    @objc func pause() {
        player?.pause()
    }
    
    @objc func play() {
        player?.play()
    }
    
    @IBAction func restartVideo(_ sender: UIButton) {
        player?.seek(to: kCMTimeZero)
        player?.play()
    }
    
    func willGestureActivate() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(pause))
        let doubleTap = UITapGestureRecognizer(target: self,action: #selector(play))
        doubleTap.numberOfTapsRequired = 2
        
        tap.require(toFail: doubleTap)
        
        playerView.addGestureRecognizer(tap)
        playerView.addGestureRecognizer(doubleTap)
    }

    @IBAction func sliderValueChanged(_ sender: UISlider) {
        player?.seek(to: CMTimeMake(Int64(sender.value*1000), 1000))
    }
    
    @IBAction func volumeChanged(_ sender: UISlider) {
        player?.volume = volumeSlider.value
    }
    
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if keyPath == "duration", let duration = player?.currentItem?.duration.seconds, duration > 0.0 {
            self.durationLabel.text = getTimeString(from: (player?.currentItem?.duration)!)
        }
    }
    
    func getTimeString(from time: CMTime) -> String {
         let totalSeconds = CMTimeGetSeconds(time)
        let hours = Int(totalSeconds/3600)
        print("Total Seconds = \(totalSeconds)")
        print("Total Hours = \(hours)")
        let minutes =  Int(totalSeconds/60) % 60
        let seconds = Int(totalSeconds.truncatingRemainder(dividingBy: 60))
        if hours > 0 {
            return String(format: "%i:%02i:%02i", arguments: [hours,minutes,seconds])
        } else {
            return String(format: "%02i:%02i", arguments: [minutes,seconds])
        }
    }
    
    func addTimeObserver() {
    let interval = CMTime(seconds: 0.5, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
    let mainQueue = DispatchQueue.main
        _ = player?.addPeriodicTimeObserver(forInterval: interval, queue: mainQueue, using: { [weak self]time in
            guard let currentItem = self?.player?.currentItem else {return}
            self?.timeSlider.maximumValue =  Float(currentItem.duration.seconds)
            self?.timeSlider.minimumValue = 0
            self?.timeSlider.value = Float(currentItem.currentTime().seconds)
            self?.currentTimeLabel.text = self?.getTimeString(from: currentItem.currentTime())
        })
    }
    
//    func addVolumeObserver() {
//        let interval = CMTime(seconds: 0.3, preferredTimescale: CMTimeScale(NSEC_PER_SEC))
//    }
    
    @IBAction func makeSpeedNormal(_ sender: UIButton) {
        
        player?.rate = 1.0
    }
    
    @IBAction func makeSpeedTo1X(_ sender: UIButton) {
        
        player?.rate = 0.5
    }
    
    @IBAction func makeSpeedTo2X(_ sender: UIButton) {
        
        player?.rate = 2.0
    }
    
    @IBAction func willMuteOrUnmute(_ sender: UISwitch) {
        if isMute {
            player?.isMuted = false
        } else {
            player?.isMuted = true
        }
        isMute = !isMute
    }
    
}
