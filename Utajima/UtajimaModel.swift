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
    var songsQuery : MPMediaQuery! = nil
    
    override init(){
        println("hi utajmamodel")
        super.init()
        self.listupAllMusics()
        
        //self.playAsong()
    }
    
    func listupAllMusics(){
        self.songsQuery = MPMediaQuery.songsQuery()
        for item in self.songsQuery.items {
            println(item.title)
            //println(item.albumTitle)
        }
    }
    
    func getMusicsCount() -> Int {
        return self.songsQuery.items.count
    }
    
    func getTitleAt(index : Int) -> String! {
        return self.songsQuery.items[index].title
    }
    
    func playAsong(){
        println("play!")
        var myPlayer = MPMusicPlayerController()
        myPlayer.setQueueWithQuery(self.songsQuery)
        myPlayer.play()
    }
}
