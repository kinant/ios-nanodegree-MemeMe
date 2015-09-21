//
//  AppDelegate.swift
//  MemeMe
//
//  Created by Kinan Turjman on 3/26/15.
//  Copyright (c) 2015 Kinan Turjman. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    // array to hold all the saved memes
    var memes = [Meme]()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        // Customize all the different UI Elementes
        
        // Customize navigation bar
        let navigationBarAppearance = UINavigationBar.appearance()
        navigationBarAppearance.tintColor = UIColor.whiteColor()
        navigationBarAppearance.barTintColor = UIColor.orangeColor()
        navigationBarAppearance.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        // Customize Tab Bar
        let tabBarAppearance = UITabBar.appearance()
        tabBarAppearance.tintColor = UIColor.whiteColor()
        tabBarAppearance.barTintColor = UIColor.orangeColor()
        
        // Customize Table View
        let tableViewAppearance = UITableView.appearance()
        tableViewAppearance.backgroundColor = UIColor.orangeColor()
        
        // Customize TableView Cells
        let tableCellAppearance = CustomTableViewCell.appearance()
        tableCellAppearance.backgroundColor = UIColor.clearColor()
        
        // Customize CollectionView Cells
        let collectionCellAppearance = UICollectionViewCell.appearance()
        collectionCellAppearance.backgroundColor = UIColor.clearColor()
        
        // Customize status bar
        UIApplication.sharedApplication().setStatusBarStyle(UIStatusBarStyle.LightContent, animated: true)
        
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
    }


}

