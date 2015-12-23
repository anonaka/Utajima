//
//  UtajimaPlayer.swift
//  Utajima
//
//  Created by nonaka on 2014/11/29.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class UtajimaPlayer: NSObject, AVAudioPlayerDelegate  {

    private var model:UtajimaModel!
    private var avPlayer:AVAudioPlayer!
    private var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    private var error: NSErrorPointer = NSErrorPointer()
    
    init(model:UtajimaModel){
        super.init()
        self.model = model
        self.setAudioSession()
        
    }
    
    private func setAudioSession(){
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error1 as NSError {
            self.error.memory = error1
        }
        do {
            try self.audioSession.setActive(true)
        } catch let error1 as NSError {
            self.error.memory = error1
        }
    }
    
    func play(song:AnyObject) -> Bool{
        if let url:NSURL = song.valueForProperty(MPMediaItemPropertyAssetURL) as? NSURL {
            self.avPlayer = try? AVAudioPlayer(contentsOfURL: url)
            self.avPlayer.delegate = self
            self.avPlayer.play()
            return true
        } else {
            // cannot play old DRM format songs
            return false
        }
        
    }
    
    func stop(){
        self.avPlayer?.stop()
        self.avPlayer = nil
    }
    
    func pause(){
        self.avPlayer?.pause()
    }
    
    func resume(){
        self.avPlayer?.play()
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer, successfully flag: Bool) {
        self.model.playDone()
    }
}
