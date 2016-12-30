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

    fileprivate var model:UtajimaModel!
    fileprivate var avPlayer:AVAudioPlayer!
    fileprivate var audioSession:AVAudioSession = AVAudioSession.sharedInstance()
    fileprivate var error: NSErrorPointer = nil
    
    init(model:UtajimaModel){
        super.init()
        self.model = model
        self.setAudioSession()
        
    }
    
    fileprivate func setAudioSession(){
        do {
            try self.audioSession.setCategory(AVAudioSessionCategoryPlayback)
        } catch let error1 as NSError {
            self.error?.pointee = error1
        }
        do {
            try self.audioSession.setActive(true)
        } catch let error1 as NSError {
            self.error?.pointee = error1
        }
    }
    
    func play(_ song:AnyObject) -> Bool{
        if let url:URL = song.value(forProperty: MPMediaItemPropertyAssetURL) as? URL {
            self.avPlayer = try? AVAudioPlayer(contentsOf: url)
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
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.model.playDone()
    }
}
