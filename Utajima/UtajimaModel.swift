//
//  UtajimaModel.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer
import CoreData

class UtajimaModel: UIResponder {
    enum PlayState { case Stopped, Playing, Paused }
    var playState:PlayState = .Stopped
    let viewController:UtajimaListTableViewController!
    var musicCollection: [AnyObject] = []
    var myPlayer:UtajimaPlayer!
    
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription?
    
    init(viewController: UtajimaListTableViewController){
        self.appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.managedContext = self.appDelegate.managedObjectContext!
        
        /* Create new ManagedObject */
        self.entity = NSEntityDescription.entityForName("Entity", inManagedObjectContext: self.managedContext)
        super.init()
        self.viewController = viewController
        self.appDelegate.model = self
        self.myPlayer = UtajimaPlayer(model: self)
    }
    
    func getMusicsCount() -> Int {
        //println("music count: \(self.musicCollection.count)")
        return self.musicCollection.count
    }
    
    func getTitleAt(index : Int) -> String? {
        return self.musicCollection[index].title?
    }

    func getAlbumTitleAt(index : Int) -> String? {
        return self.musicCollection[index].albumTitle?
    }
    
    func getArtworkAt(index : Int) -> MPMediaItemArtwork? {
        //TODO retuen default artwork when nil
        return self.musicCollection[index].artwork?
    }

    func addSongToPlaybackQueue(mediaCollection:MPMediaItemCollection){
        // add a selected song to the playback queue
        self.viewController.reloadInputViews()
        self.musicCollection +=  mediaCollection.items
        
    }
    
    func removePlaybackQueueAtIndex(index:Int){
        self.musicCollection.removeAtIndex(index)
    }
    
    
    func movePlaybackQueue(from:Int,to:Int){
        let tmpobj:AnyObject = self.musicCollection[from]
        self.musicCollection.removeAtIndex(from)
        self.musicCollection.insert(tmpobj, atIndex: to)
    }
    
    func play(){
        if self.musicCollection.isEmpty == true {
            self.playState = .Stopped
        } else {
            let song:AnyObject = self.musicCollection[0]
            self.myPlayer.play(song)
            self.playState = .Playing
        }
        self.viewController.updatePlayPauseButton()
        
        self.saveMusicCollection()
    }
    
    func pause(){
        self.myPlayer.pause()
        self.playState = .Paused
        self.viewController.updatePlayPauseButton()
    }
    
    func resume(){
        if self.playState != .Paused {
            println("State transition error")
            // must throw exception here
        } else {
            self.myPlayer!.resume()
            self.playState = .Playing
        }
        self.viewController.updatePlayPauseButton()
    }
    
    func fastForward(){
        self.stop()
        self.playDone()
    }
    
    func rewind(){
        self.play()
    }
    
    func stop(){
        self.myPlayer.stop()
        self.playState = .Stopped
        self.viewController.updatePlayPauseButton()
    }
    
    func playDone(){
        if !self.musicCollection.isEmpty {
            self.musicCollection.removeAtIndex(0)
        }
        self.viewController.tableView.reloadData()
        self.play()
    }
    
    func saveMusicCollection(){
        // save music list to CoreData
        var pidList:[NSNumber] = []
        for song in self.musicCollection {
            var pid = song.valueForProperty(MPMediaItemPropertyPersistentID) as NSNumber
            pidList.append(pid)
        }
        self.writeCoreData(pidList)
    }

    func writeCoreData(pidList:[NSNumber]){
        
    }
}
