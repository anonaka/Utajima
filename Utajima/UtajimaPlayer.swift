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
        self.audioSession.setCategory(AVAudioSessionCategoryPlayback, error: self.error)
        self.audioSession.setActive(true, error: self.error)
    }
    
    func play(song:AnyObject){
        //TODO next line may throw exception. Must catch. anonaka 6/30/2015
        let url:NSURL = song.valueForProperty(MPMediaItemPropertyAssetURL) as! NSURL
        //TODO end
        self.avPlayer = AVAudioPlayer(contentsOfURL: url, error: nil)
        self.avPlayer.delegate = self
        self.avPlayer.play()
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
    
    func audioPlayerDidFinishPlaying(player: AVAudioPlayer!, successfully flag: Bool) {
        self.model.playDone()
    }
}
