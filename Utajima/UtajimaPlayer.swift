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
    var model:UtajimaModel! = nil
    var avPlayer:AVAudioPlayer? = nil
    var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    var error: NSErrorPointer = NSErrorPointer()
    
    init(model:UtajimaModel){
        super.init()
        self.model = model
        self.setAudioSession()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
   }
    
    func statusChanged(notification: NSNotification?){
    }

    func get1stSong() -> AnyObject?{
        if self.model.musicCollection.isEmpty == false {
            return self.model.musicCollection[0]
        } else {
            return nil
        }
    }
    
    func play1st(){
        var song : AnyObject? = self.get1stSong()
        if song == nil {return}
        let url:NSURL = song?.valueForProperty(MPMediaItemPropertyAssetURL) as NSURL
        self.avPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        self.avPlayer!.delegate = self
        println("Duration: \(self.avPlayer!.duration)")
        self.avPlayer!.play()
    }
    
    func setAudioSession(){
        self.audioSession.setCategory(AVAudioSessionCategoryPlayback, error: self.error)
        self.audioSession.setActive(true, error: self.error)
    }
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.model.playDone()
    }
}
