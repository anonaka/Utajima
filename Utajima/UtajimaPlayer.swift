//
//  UtajimaPlayer.swift
//  Utajima
//
//  Created by nonaka on 2014/11/29.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer

class UtajimaPlayer: NSObject {
    // application music player does not work in background...
    let mpPlayer = MPMusicPlayerController.iPodMusicPlayer()
    var model:UtajimaModel! = nil
    
    init(model:UtajimaModel){
        super.init()
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
        if (mpPlayer.playbackState == MPMusicPlaybackState.Stopped) {
            println("Stopped")
        }
    }

    //TODO need revise
    func getNextSongAndPlay() -> AnyObject {
        return self.model.getNextSong()
    }
    
    func get1stSong() -> AnyObject{
        return self.model.musicCollection[0]
    }
    
    func play1st(){
        var items:MPMediaItemCollection = MPMediaItemCollection(items:[self.get1stSong()])
        mpPlayer.setQueueWithItemCollection(items)
        mpPlayer.play()
        self.mpPlayer.beginGeneratingPlaybackNotifications()
    }
}
