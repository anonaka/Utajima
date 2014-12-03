//
//  UtajimaListTableViewController.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import MediaPlayer

class UtajimaListTableViewController: UITableViewController, MPMediaPickerControllerDelegate{
    
    @IBOutlet weak var AddSongButton: UIBarButtonItem!
    var utajimaModel: UtajimaModel!  = nil
    let myMediaPicker = MPMediaPickerController(mediaTypes: MPMediaType.Music)
    	
    override func viewDidLoad() {
        super.viewDidLoad()       
        //self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.utajimaModel = UtajimaModel(viewController: self)

        var tap = UITapGestureRecognizer(target: self, action: "respondToTap:")
        tap.numberOfTapsRequired = 2
        self.view.addGestureRecognizer(tap)
        
        // add swipe action
        var swipeRight = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeRight.direction = UISwipeGestureRecognizerDirection.Right
        self.view.addGestureRecognizer(swipeRight)
        
        var swipeDown = UISwipeGestureRecognizer(target: self, action: "respondToSwipeGesture:")
        swipeDown.direction = UISwipeGestureRecognizerDirection.Down
        self.view.addGestureRecognizer(swipeDown)

        self.myMediaPicker.allowsPickingMultipleItems = true
        self.myMediaPicker.delegate = self
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        self.navigationItem.rightBarButtonItem = self.editButtonItem()
        
        self.addFooter()
    }


    @IBAction func play(sender: AnyObject) {
    }
    
    @IBAction func addSongsToPlaybackQueue(sender: AnyObject) {
        self.runMediaPicker()
    }
    
    func runMediaPicker() {
        self.hideController(true)
        self.presentViewController(self.myMediaPicker, animated: true, completion: nil)
    }
    
    func mediaPicker(mediaPicker: MPMediaPickerController!,
        didPickMediaItems mediaItemCollection: MPMediaItemCollection!){
        mediaPicker.dismissViewControllerAnimated(true, completion: nil)
        self.utajimaModel.addSongToPlaybackQueue(mediaItemCollection)
        self.hideController(false)
        return
    }
    
    func mediaPickerDidCancel(){
         println("music pickup cancelled")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return self.utajimaModel.getMusicsCount()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell", forIndexPath: indexPath) as UITableViewCell

        // Configure the cell...
        cell.textLabel.text = self.utajimaModel.getTitleAt(indexPath.row)
        cell.detailTextLabel?.text = self.utajimaModel.getAlbumTitleAt(indexPath.row)
        var image:UIImage? = self.utajimaModel.getArtworkAt(indexPath.row)?.imageWithSize(CGSizeMake(80.0,80.0))
        cell.imageView.image = image
        return cell
    }
    
    func updateVisibleCells(){
        for vc in self.tableView.visibleCells() as [UITableViewCell]{
            vc.reloadInputViews()
        }
    }
        
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    }
    
    func respondToTap(sender: UITapGestureRecognizer) {
        if sender.state == .Ended {
            self.utajimaModel.play()
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
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
    
    //Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // must update the model before update view
            self.utajimaModel.removePlaybackQueueAtIndex(indexPath.row)
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)

        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }

    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {
        self.utajimaModel.movePlaybackQueue(fromIndexPath.row, to: toIndexPath.row)
    }

    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        if indexPath.row == 0 {
            return false
        } else {
            return true
        }
    }
   
    
    // Build Footer
    //TODO refacter these !!
    let footerHeight:CGFloat = CGFloat(70.0)
    var utajimaControllerView: UIView? = nil;
    
//    override func tableView(tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
//        return self.footerHeight
//    }
//    override func tableView(tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
//        let footerFrame:CGRect = CGRect(
//            x: 0.0,
//            y: tableView.frame.height - footerHeight,
//            width: tableView.frame.width,
//            height: self.footerHeight)
//        let footerView:UIView = UIView(frame: footerFrame)
//        footerView.backgroundColor = UIColor.darkGrayColor()
//        return footerView
//    }

    
    func addFooter(){
        let appDelegate:UIApplicationDelegate? = UIApplication.sharedApplication().delegate
        let footerFrame:CGRect = CGRect(
            x: 0.0,
            //y: self.tableView.frame.height - self.footerHeight,
            y: UIScreen.mainScreen().bounds.height - self.footerHeight,
            width: UIScreen.mainScreen().bounds.width,
            height: self.footerHeight)
        self.utajimaControllerView = UIView(frame: footerFrame)
        self.utajimaControllerView!.backgroundColor =  UIColor.redColor()
        appDelegate?.window??.addSubview(self.utajimaControllerView!)
        //self.tableView.tableFooterView = footer
    }
    
    func hideController(mode:Bool){
        self.utajimaControllerView!.hidden = mode
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
