//
//  AppDelegate.swift
//  AskAway
//
//  Created by Daniel Salib on 4/7/18.
//  Copyright © 2018 cis195. All rights reserved.
//

import UIKit

let primaryColor = UIColor(red: 63/255, green: 67/255, blue: 74/255, alpha: 1)
let secondaryColor = UIColor(red: 42/255, green: 43/255, blue: 45/255, alpha: 1)
let mainColor = UIColor(red: 56/255, green: 62/255, blue: 72/255, alpha: 1)
let backgroundColor = UIColor(red: 0.91, green: 0.91, blue: 0.91, alpha: 1)
let buttonColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)
let cellColor = UIColor(red: 217/255, green: 217/255, blue: 217/255, alpha: 1)
let shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.5)
let disabledColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)

var currentUser: Profile? {
    didSet{
        print(currentUser!.firstName)
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

