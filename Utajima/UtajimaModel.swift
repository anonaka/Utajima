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
    var musicCollection: [MPMediaItem] = []
    var myPlayer:UtajimaPlayer!
    
    let appDelegate: AppDelegate
    let managedContext: NSManagedObjectContext
    let entity: NSEntityDescription?
    let entityName = "SongPidList"
    let maxQueueLength = 30

    init(viewController: UtajimaListTableViewController){
        self.appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        self.managedContext = self.appDelegate.managedObjectContext!
        self.viewController = viewController
        /* Create new ManagedObject */
        self.entity = NSEntityDescription.entityForName("SongPidList", inManagedObjectContext: self.managedContext)
        super.init()
        self.appDelegate.model = self
        self.myPlayer = UtajimaPlayer(model: self)
        self.fetchMusicCollection()
    }
    
    func getMusicsCount() -> Int {
        return self.musicCollection.count
    }
    
    func getTitleAt(index : Int) -> String? {
        return self.musicCollection[index].title
    }

    func getAlbumTitleAt(index : Int) -> String? {
        return self.musicCollection[index].albumTitle
    }
    
    func getArtworkAt(index : Int) -> MPMediaItemArtwork? {
        //TODO retuen default artwork when nil
        if let aw = self.musicCollection[index].artwork {
            return aw
        } else {
            return nil
        }
    }

    func addSongToPlaybackQueue(mediaCollection:MPMediaItemCollection){
        // add a selected song to the playback queue
        self.musicCollection += mediaCollection.items
        self.truncateQueue()
        self.viewController.reloadInputViews()
        self.viewController.tableView.reloadData()
    }
    
    func truncateQueue() {
        while self.maxQueueLength < self.musicCollection.count {
           self.musicCollection.removeLast()
        }
    }
    
    func removePlaybackQueueAtIndex(index:Int){
        self.musicCollection.removeAtIndex(index)
    }
    
    
    func movePlaybackQueue(from:Int,to:Int){
        let tmpobj:MPMediaItem = self.musicCollection[from]
        self.musicCollection.removeAtIndex(from)
        self.musicCollection.insert(tmpobj, atIndex: to)
    }
    
    func play() -> Bool {
        if self.musicCollection.isEmpty == true {
            self.playState = .Stopped
        } else {
            let song:AnyObject = self.musicCollection[0]
            if (self.myPlayer.play(song)) {
                self.playState = .Playing
            } else {
                //cannot play a song due to error
                viewController.showUtajimaAlert("Cannot play Old DRM format music!")
                self.stop()
                self.removeMusicFromCollection()
                return false
            }
        }
        self.viewController.updatePlayPauseButton()
        self.saveMusicCollection()
        return true
    }
    
    func pause(){
        self.myPlayer.pause()
        self.playState = .Paused
        self.viewController.updatePlayPauseButton()
    }
    
    func resume(){
        if self.playState != .Paused {
            print("State transition error")
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
        self.removeMusicFromCollection()
        self.play()
    }
    
    func removeMusicFromCollection(){
        if !self.musicCollection.isEmpty {
            self.musicCollection.removeAtIndex(0)
        }
        self.viewController.tableView.reloadData()
    }

    
    func saveMusicCollection(){
        // delet all data first
        fetchMusicCollection(true)
        // save music list to CoreData
        var pidList:[NSNumber] = []
        for song in self.musicCollection {
            let pid = song.valueForProperty(MPMediaItemPropertyPersistentID) as! NSNumber
            pidList.append(pid)
        }
        self.writeCoreData(pidList)
    }

    func writeCoreData(pidList:[NSNumber]){
        for pid in pidList {
            let managedObject: AnyObject = NSEntityDescription.insertNewObjectForEntityForName(self.entityName , inManagedObjectContext: self.managedContext)
            // エンティティモデルにデータをセット
            let model = managedObject as! SongPidList
            model.songPersistendId = pid
        }
        /* Error handling */
        var error: NSError?
        do {
            try self.managedContext.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    func fetchMusicCollection(delete: Bool = false){
    
        /* Set search conditions */
        let fetchRequest = NSFetchRequest(entityName: self.entityName)
        var error: NSError?
        
        /* Get result array from ManagedObjectContext */
        let fetchResults: [AnyObject]?
        do {
            fetchResults = try self.managedContext.executeFetchRequest(fetchRequest)
        } catch let error1 as NSError {
            error = error1
            fetchResults = nil
        }
        if let results: Array = fetchResults {
            for obj:AnyObject in results {
                if delete == true {
                    self.managedContext.deleteObject(obj as! NSManagedObject)
                } else {
                    let pid:NSNumber? = obj.valueForKey("songPersistendId") as? NSNumber
                    if pid != nil {
                        if let item:MPMediaItem = getMediaItemFromPid(pid){
                            self.musicCollection.append(item)
                        }
                    }
                }
            }
        } else {
            print("Could not fetch \(error) , \(error!.userInfo)")
        }
    }
    
    func getMediaItemFromPid(pid:NSNumber?) -> MPMediaItem? {
        let pred = MPMediaPropertyPredicate(value:pid, forProperty: MPMediaItemPropertyPersistentID)
        let query = MPMediaQuery()
        query.addFilterPredicate(pred)
        if query.items!.count > 0 {
            return query.items![0]
        } else {
            return nil
        }
    }
}
