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

class UtajimaPlayer: NSObject {
    // application music player does not work in background...
    let mpPlayer = MPMusicPlayerController.applicationMusicPlayer()
    var model:UtajimaModel! = nil
    
    init(model:UtajimaModel){
        super.init()
        self.mpPlayer.repeatMode = .None
        self.model = model
        let notificationCenter = NSNotificationCenter.defaultCenter()
 
        /*
        notificationCenter.addObserver(
            self,
            selector: "statusChanged:",
            name: "MPMusicPlayerControllerNowPlayingItemDidChangeNotification",
            object: self.mpPlayer)
        
        */
       
        notificationCenter.addObserver(
            self,
            selector: "statusChanged:",
            name: "MPMusicPlayerControllerPlaybackStateDidChangeNotification",
            object: self.mpPlayer)
        
    }
    
    func statusChanged(notification: NSNotification?){
        if (mpPlayer.playbackState == .Stopped) {
            self.model.playDone()
        }
    }

    func get1stSong() -> AnyObject?{
        if self.model.musicCollection.isEmpty == false {
            return self.model.musicCollection[0]
        } else {
            return nil
        }
    }
    
    func play1st(){
        if (mpPlayer.playbackState != .Playing) {
            //TODO there must be smarter way to do this check
            var song : AnyObject? = self.get1stSong()
            if song == nil {return}
            
            var items:MPMediaItemCollection = MPMediaItemCollection(items:[song!])
            mpPlayer.setQueueWithItemCollection(items)
            mpPlayer.play()
            self.mpPlayer.beginGeneratingPlaybackNotifications()
        }
    }
}
