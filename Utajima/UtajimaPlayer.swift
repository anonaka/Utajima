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
    let mpPlayer = MPMusicPlayerController.applicationMusicPlayer()
    var model:UtajimaModel! = nil
    
    init(model:UtajimaModel){
        self.model = model
    }
    
    func getNextSong() -> AnyObject {
        return self.model.getNextSong()
    }
    
    func play1st(){
        var items:MPMediaItemCollection = MPMediaItemCollection(items:[self.getNextSong()])
        mpPlayer.setQueueWithItemCollection(items)
        mpPlayer.play()
    }
}
