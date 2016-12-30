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
 
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    override func remoteControlReceived(with event: UIEvent?) {
        if (event!.type == .remoteControl) {
            switch (event!.subtype) {
            case .remoteControlPlay:
                self.doPlay(self)
            case .remoteControlStop:
                self.doPlay(self)
            case .remoteControlPause:
                self.self.doPlay(self)
            case .remoteControlNextTrack:
                self.DoFF(self)
            case .remoteControlPreviousTrack:
                self.doRewind(self)
            case .remoteControlTogglePlayPause:
                self.doPlay(self)
            case .remoteControlEndSeekingBackward:
                self.doRewind(self)
            case .remoteControlEndSeekingForward:
                self.DoFF(self)
            default:
                print("Event not handled:\(event!.subtype.rawValue)")
             }
        }
    }
    
    func initButtons(){
        self.playButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.play, target: self, action: #selector(UtajimaListTableViewController.doPlay(_:)))
        self.pauseButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.pause, target:self, action: #selector(UtajimaListTableViewController.doPlay(_:)))
        self.updatePlayPauseButton()
    }
    
    func updatePlayPauseButton(){
        let PlayPauseButtonOffset:Int = 2
        if self.model.playState == .playing {
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

        
        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        self.initButtons()
        UIApplication.shared.beginReceivingRemoteControlEvents()
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated:animated)
        self.tableView.setEditing(editing, animated: animated)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //TODO check if I can write this one line
        if self.tableView.indexPathForSelectedRow != nil {
            self.tableView.deselectRow(at: self.tableView.indexPathForSelectedRow!, animated:animated)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        tableView.flashScrollIndicators()
    }
    
    override func didRotate(from fromInterfaceOrientation: UIInterfaceOrientation) {
        tableView.flashScrollIndicators()
    }
    
    @IBAction func play(_ sender: AnyObject) {
    }
    
    @IBAction func addSongsToPlaybackQueue(_ sender: AnyObject) {
        self.runMediaPicker()
    }
    
    func runMediaPicker() {
        let myMediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.music)
        myMediaPicker.allowsPickingMultipleItems = true
        myMediaPicker.delegate = self
        self.present(myMediaPicker, animated: true, completion: nil)
    }
    
    func mediaPicker(_ mediaPicker: MPMediaPickerController,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection){
            mediaPicker.dismiss(animated: true, completion: nil)
            self.model.addSongToPlaybackQueue(mediaItemCollection)
            return
    }
    
    func mediaPickerDidCancel(_ mediaPicker: MPMediaPickerController) {
        mediaPicker.dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.model.getMusicsCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) 

        // Configure the cell...
        //TODO fix bug
        // 5/30/2015 program chrash here when core data is corrupted...
        cell.textLabel?.text = self.model.getTitleAt(indexPath.row)
        cell.detailTextLabel?.text = self.model.getAlbumTitleAt(indexPath.row)
        let image:UIImage? = self.model.getArtworkAt(indexPath.row)?.image(at: CGSize(width: 80.0,height: 80.0))
        cell.imageView?.image = image
        return cell
    }
    
    func updateVisibleCells(){
        for vc in self.tableView.visibleCells {
            vc.reloadInputViews()
        }
    }
        
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
    }
    
    func respondToTap(_ sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            //self.model.play()
        }
    }
 
    func respondToSwipeGesture(_ gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                print("Swiped right")
            case UISwipeGestureRecognizerDirection.down:
                print("Swiped down")
            default:
                break
            }
        }
    }
    
    // Override to support conditional editing of the table view.
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    //Override to support editing the table view.
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // must update the model before update view
            self.model.removePlaybackQueueAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)

        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support conditional rearranging of the table view.
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    func tableView(_ tableView: UITableView,
        targetIndexPathForMoveFromRowAt sourceIndexPath: IndexPath,
        toProposedIndexPath proposedDestinationIndexPath: IndexPath) -> IndexPath {
        
        if (proposedDestinationIndexPath.row < 2) {
            return IndexPath(row: 1, section: proposedDestinationIndexPath.section)
        } else {
            return proposedDestinationIndexPath
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        self.model.movePlaybackQueue(sourceIndexPath.row,to: destinationIndexPath.row)
    }
    
    @IBAction func doRewind(_ sender: AnyObject) {
        self.model.rewind()
    }
    
    @IBAction func doPlay(_ sender: AnyObject) {
        switch self.model.playState {
        case .stopped:
            if self.model.play() {
             self.playPauseButton = self.pauseButton
            }
        case .paused:
            self.model.resume()
        case .playing:
            self.model.pause()
        default:
            print("state error")
            //TODO must thorow exception here
        }
    }
    
    @IBAction func DoFF(_ sender: AnyObject) {
        self.model.fastForward()
    }
    
    func showUtajimaAlert(_ errMsg: String){
        let alert:UIAlertController = UIAlertController(title:"Alert",
            message: errMsg,
            preferredStyle: UIAlertControllerStyle.alert
        )
        // Default 複数指定可
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.default,
            handler:{
                (action:UIAlertAction) -> Void in
                print("OK")
        })
        alert.addAction(defaultAction)
        self.present(alert, animated: true, completion: nil)
    }

}
