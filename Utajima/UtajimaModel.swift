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
    var musicCollection: [AnyObject] = []
    var myPlayer:UtajimaPlayer! = nil
    
    init(viewController: UtajimaListTableViewController){
        println("hi utajmamodel")
        super.init()
        self.viewController = viewController
        self.myPlayer = UtajimaPlayer(model: self)
    }
    
    func getMusicsCount() -> Int {
        return self.musicCollection.count
    }
    
    func getTitleAt(index : Int) -> String! {
        println(self.musicCollection[index].title)
        return self.musicCollection[index].title
    }
    
    func addSongToPlaybackQueue(mediaCollection:MPMediaItemCollection){
        // add a selected song to the playback queue
        //TODO reload all the cells in table view
        self.viewController.reloadInputViews()
        //self.viewController.updateVisibleCells()
        self.musicCollection +=  mediaCollection.items

        //self.myPlayer.play1st()
    }
}
