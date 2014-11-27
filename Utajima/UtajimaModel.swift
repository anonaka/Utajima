//
//  UtajimaModel.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer
import AVFoundation

class UtajimaModel: NSObject {
    var playbackQueue : MPMediaQuery! = nil
    let myPlayer = MPMusicPlayerController()
    
    override init(){
        println("hi utajmamodel")
        super.init()
    }
    
    
    /*
    func listupAllMusics(){
        self.songsQuery = MPMediaQuery.songsQuery()
        for item in self.songsQuery.items {
            println(item.title)
            //println(item.albumTitle)
        }
    }
    */
    
    func getMusicsCount() -> Int {
        if (self.playbackQueue != nil){
            return self.playbackQueue.items.count
        } else {
            return 0
        }
    }
    
    func getTitleAt(index : Int) -> String! {
        return self.playbackQueue.items[index].title
    }
    
    func addSongToPlaybackQueue(aSong : MPMediaQuery){
        // add a selected song to the playback queue
    }
    
    func playAsong(){
        println("play!")
        myPlayer.setQueueWithQuery(self.playbackQueue)
        myPlayer.play()
    }
}
