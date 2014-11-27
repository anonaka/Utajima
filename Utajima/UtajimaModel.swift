//
//  UtajimaModel.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer

class UtajimaModel: NSObject {
    
    var viewController:UtajimaListTableViewController! = nil
    var musicCollection:MPMediaItemCollection! = nil
    let myPlayer = MPMusicPlayerController.applicationMusicPlayer()
    
    init(viewController: UtajimaListTableViewController){
        println("hi utajmamodel")
        self.viewController = viewController
        super.init()
    }
    
    func getMusicsCount() -> Int {
        if (self.musicCollection != nil){
            return self.musicCollection.items.count
        } else {
            return 0
        }
    }
    
    func getTitleAt(index : Int) -> String! {
        println(self.musicCollection.items[index].title)
        return self.musicCollection.items[index].title
    }
    
    func addSongToPlaybackQueue(items:MPMediaItemCollection){
        // add a selected song to the playback queue
        println("add songs to the playback queue")
        self.musicCollection = items
        self.viewController.reloadInputViews()
        myPlayer.setQueueWithItemCollection(items)
        myPlayer.play()
    }
}
