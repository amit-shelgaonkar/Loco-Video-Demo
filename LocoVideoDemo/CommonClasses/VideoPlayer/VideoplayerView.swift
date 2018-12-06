//
//  VideoplayerView.swift
//  LocoVideoDemo
//
//  Created by Mindbowser on 05/12/18.
//  Copyright © 2018 Mindbowser. All rights reserved.
//

import UIKit
import AVKit
import AVFoundation
class VideoplayerView: UIView {

    var playerLayer: AVPlayerLayer?
    var videoPlayer: AVPlayer?
    var repeatVideo: Bool = false
    
    override var frame: CGRect {
        didSet {
        
            if(Int(bounds.size.width) <= boundedWidth)
            {
                playerLayer?.frame.size.width = 90
                playerLayer?.frame.size.height = (playerLayer!.frame.size.width) * 1.7
            }
            else{
                playerLayer?.frame = bounds
            }
            playerLayer?.videoGravity = AVLayerVideoGravity.resize
        }
    }
    
    
    // MARK: Configure the Video View
    
    func configureVideoplayer() {
        guard let path = Bundle.main.path(forResource: "videoplayback", ofType:"mp4") else {
            debugPrint("Video not found")

            return
        }
        videoPlayer = AVPlayer(url: URL(fileURLWithPath: path))
        
        playerLayer = AVPlayerLayer(player: videoPlayer)
        playerLayer?.frame = bounds
        playerLayer?.needsDisplayOnBoundsChange = true
        if let playerLayer = self.playerLayer {
            layer.addSublayer(playerLayer)
        }
        NotificationCenter.default.addObserver(self, selector: #selector(reachTheEndOfTheVideo(_:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: self.videoPlayer?.currentItem)
    }
    
    // MARK: Play the Video
    
    func play() {
        if videoPlayer?.timeControlStatus != AVPlayerTimeControlStatus.playing {
            videoPlayer?.play()
        }
        else
        {
            debugPrint("Unable to play video")
        }
    }
    
    // MARK: Pause the Video
    
    func pause() {
        videoPlayer?.pause()
    }
    
    // MARK: Stop the Video and set video seektime to 0
    
    func stop() {
        videoPlayer?.pause()
        videoPlayer?.seek(to: kCMTimeZero)
    }
    
    // MARK: Video Completion listner method
    
    @objc func reachTheEndOfTheVideo(_ notification: Notification) {
        // check if repeat video is true then restart video
        if repeatVideo {
            videoPlayer?.pause()
            videoPlayer?.seek(to: kCMTimeZero)
            videoPlayer?.play()
        }
    }

}
