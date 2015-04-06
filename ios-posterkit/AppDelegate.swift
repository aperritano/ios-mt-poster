//
//  AppDelegate.swift
//  ios-mt-poster
//
//  Created by Anthony Perritano on 2/28/15.
//  Copyright (c) 2015 LTG. All rights reserved.
//

import UIKit
import CoreData


 let colors: [UIColor] = [UIColor.paperColorRed400(), UIColor.paperColorIndigo400(), UIColor.paperColorPink400(), UIColor.paperColorLightBlue400(), UIColor.paperColorAmber400(), UIColor.paperColorOrange400(), UIColor.paperColorBrown400(), UIColor.paperColorTeal400(), UIColor.paperColorPink400(), UIColor.paperColorBlue400(), UIColor.paperColorGray400(), UIColor.paperColorDeepPurple400(), UIColor.paperColorGreen400()]

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject:AnyObject]?) -> Bool {


//        
//        var navController : UINavigationController = self.window?.rootViewController as UINavigationController
//        
//        navController.navigationBarClas
        
        
        
        
        //UIApplication.sharedApplication().statusBarStyle = .LightContent

       //FLEXManager.sharedManager().showExplorer()

        UINavigationBar.appearance().titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()];
////
        UINavigationBar.appearance().barTintColor = UIColor.paperColorGray600()
        UINavigationBar.appearance().tintColor = UIColor.whiteColor()
//
       UIApplication.sharedApplication().statusBarStyle = .LightContent
////
        UIApplication.sharedApplication().statusBarStyle = UIStatusBarStyle.LightContent
//        // Override point for customization after application launch.

        //MQTTPipe.sharedInstance.sendMessage("POSTER HELPER ONLINE")

        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(application: UIApplication) {
        // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
    }

  
}

