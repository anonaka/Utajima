//
//  UtajimaListTableViewController.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer

class UtajimaListTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, MPMediaPickerControllerDelegate {
    
    @IBOutlet weak var playPauseButton: UIBarButtonItem!
    @IBOutlet weak var fastforwardButton: UIBarButtonItem!
    @IBOutlet weak var rewindButton: UIBarButtonItem!
    @IBOutlet weak var addSongButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var controllerBar: UIToolbar!
    
    var playButton:UIBarButtonItem!
    var pauseButton:UIBarButtonItem!

    var model:UtajimaModel!  = nil
    let myMediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.Music)

    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func remoteControlReceivedWithEvent(event: UIEvent) {
        if (event.type == .RemoteControl) {
            switch (event.subtype) {
            case .RemoteControlPlay:
                self.doPlay(self)
            case .RemoteControlStop:
                self.doPlay(self)
            case .RemoteControlPause:
                self.self.doPlay(self)
            case .RemoteControlNextTrack:
                self.DoFF(self)
            case .RemoteControlPreviousTrack:
                self.doRewind(self)
            case .RemoteControlTogglePlayPause:
                self.doPlay(self)
            case .RemoteControlEndSeekingBackward:
                self.doRewind(self)
            case .RemoteControlEndSeekingForward:
                self.DoFF(self)
            default:
                println("Event not handled:\(event.subtype.rawValue)")
             }
        }
    }
    
    func initButtons(){
        self.playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Play, target: self, action: Selector("doPlay:"))
        self.pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Pause, target:self, action: Selector("doPlay:"))
        self.updatePlayPauseButton()
    }
    
    func updatePlayPauseButton(){
        let PlayPauseButtonOffset:Int = 2
        if self.model.playState == .Playing {
            self.controllerBar.items![PlayPauseButtonOffset] = self.pauseButton
        } else {
            self.controllerBar.items![PlayPauseButtonOffset] = self.playButton
        }
    }
   
    override func viewDidLoad() {
        super.viewDidLoad()       
        self.model = UtajimaModel(viewController: self)
        
        self.tableView.dataSource = self
        self.tableView.delegate = self

        self.myMediaPicker.allowsPickingMultipleItems = true
        self.myMediaPicker.delegate = self
        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.initButtons()
        UIApplication.sharedApplication().beginReceivingRemoteControlEvents()
    }
    
    override func setEditing(editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //TODO check if I can write this one line
        if self.tableView.indexPathForSelectedRow() != nil {
            self.tableView.deselectRowAtIndexPath(self.tableView.indexPathForSelectedRow()!, animated:animated)
        }
    }

    override func viewDidAppear(animated: Bool) {
        tableView.flashScrollIndicators()
    }
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.flashScrollIndicators()
    }
    
    @IBAction func play(sender: AnyObject) {
    }
    
    @IBAction func addSongsToPlaybackQueue(sender: AnyObject) {
        self.runMediaPicker()
    }
    
    func runMediaPicker() {
        //self.hideController(true)
        self.presentViewController(self.myMediaPicker, animated: true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController!,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection!){
            mediaPicker.dismissViewControllerAnimated(true, completion: nil)
            self.model.addSongToPlaybackQueue(mediaItemCollection)
            return
    }
    
    func mediaPickerDidCancel(mediaPicker: MPMediaPickerController!) {
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.model.getMusicsCount()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...
        cell.textLabel?.text = self.model.getTitleAt(indexPath.row)
        cell.detailTextLabel?.text = self.model.getAlbumTitleAt(indexPath.row)
        var image:UIImage? = self.model.getArtworkAt(indexPath.row)?.imageWithSize(CGSizeMake(80.0,80.0))
        cell.imageView?.image = image
        return cell
    }
    
    func updateVisibleCells(){
        for vc in self.tableView.visibleCells() as! [UITableViewCell]{
            vc.reloadInputViews()
        }
    }
        
    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func respondToTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            //self.model.play()
        }
    }
 
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.Right:
                println("Swiped right")
            case UISwipeGestureRecognizerDirection.Down:
                println("Swiped down")
            default:
                break
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    //Override to support editing the table view.
    func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // must update the model before update view
            self.model.removePlaybackQueueAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support conditional rearranging of the table view.
    func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(tableView: UITableView,
        targetIndexPathForMoveFromRowAtIndexPath sourceIndexPath: NSIndexPath,
        toProposedIndexPath proposedDestinationIndexPath: NSIndexPath) -> NSIndexPath {
        
        if (proposedDestinationIndexPath.row < 2) {
            return NSIndexPath(forRow: 1, inSection: proposedDestinationIndexPath.section)
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    func tableView(tableView: UITableView, moveRowAtIndexPath sourceIndexPath: NSIndexPath, toIndexPath destinationIndexPath: NSIndexPath) {
        self.model.movePlaybackQueue(sourceIndexPath.row,to: destinationIndexPath.row)
    }
    
    @IBAction func doRewind(sender: AnyObject) {
        self.model.rewind()
    }
    
    @IBAction func doPlay(sender: AnyObject) {
        switch self.model.playState {
        case .Stopped:
            self.model.play()
            self.playPauseButton = self.pauseButton
        case .Paused:
            self.model.resume()
        case .Playing:
            self.model.pause()
        default:
            println("state error")
            //TODO must thorow exception here
        }
    }
    
    @IBAction func DoFF(sender: AnyObject) {
        self.model.fastForward()
    }

}
