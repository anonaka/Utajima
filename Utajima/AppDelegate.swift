//
//  AppDelegate.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit
import AVFoundation

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var model : UtajimaModel!
    let nc = NSNotificationCenter.defaultCenter()

    override init(){
        super.init()
        self.nc.addObserver(self, selector: Selector("rounteChangeEventHandler:"),
            name: AVAudioSessionRouteChangeNotification,
            object: nil)
    }
    
    func rounteChangeEventHandler(notification: NSNotification){
        println("Got notification: \(notification.name)")
        if let reason: AnyObject = notification.userInfo![AVAudioSessionRouteChangeReasonKey]{
            if let r = AVAudioSessionRouteChangeReason(rawValue: UInt(reason.integerValue)) {
                switch r {
                case .NewDeviceAvailable:
                    println("New device available")
                case .OldDeviceUnavailable:
                    println("Old device unavaiable")
                    self.model.stop()
                default:
                    println("Other reason:\(r)")
                }
            } else {
                println ("Other reason")
            }
        }
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

