//
//  AppDelegate.swift
//  Utajima
//
//  Created by nonaka on 2014/11/22.
//  Copyright (c) 2014年 nonaka@mac.com. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let backgroundQueue = dispatch_get_global_queue(QOS_CLASS_BACKGROUND,0)
    var model : UtajimaModel? = nil
    var bgTaskId:UIBackgroundTaskIdentifier = UIBackgroundTaskInvalid
    
    override init(){
        super.init()
    }
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }


    
    func applicationDidEnterBackground(application: UIApplication) {
        println("Did enter background: \(self.bgTaskId)")
        if (self.bgTaskId == UIBackgroundTaskInvalid){
            self.bgTaskId = application.beginBackgroundTaskWithName("myBgTask", expirationHandler: myExpiratonHandler)
            println("New bg task id : \(self.bgTaskId)")
        }
        //dispatch_async(self.backgroundQueue, myBackgroundTask)
    }
    

    func myBackgroundTask() {
        // this is not elegant but works for now...
        NSThread.sleepForTimeInterval(30.0)
        println("this is back ground task")
        var time = UIApplication.sharedApplication().backgroundTimeRemaining
        println(String(format: "Time remaining: %.3f sec" ,time))
        dispatch_async(self.backgroundQueue, myBackgroundTask)
    }
    
    func myExpiratonHandler(){
        let application:UIApplication = UIApplication.sharedApplication()
        println("Expiration handler called: \(self.bgTaskId)")
        let oldTaksId = self.bgTaskId
        self.bgTaskId = application.beginBackgroundTaskWithName("myBgTask", expirationHandler: myExpiratonHandler)
        
        if (self.bgTaskId == UIBackgroundTaskInvalid){
            println("Cannot launch bg task any more")
        } else {
            println("New bg task id : \(self.bgTaskId)")
        }
        if (oldTaksId != UIBackgroundTaskInvalid) {
            println("Terminate old bg task \(oldTaksId)")
            application.endBackgroundTask(self.bgTaskId)
        }
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
        application.endBackgroundTask(self.bgTaskId)
        self.bgTaskId = UIBackgroundTaskInvalid
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        // wonder if this is necessary...
        application.endBackgroundTask(self.bgTaskId)
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
}

