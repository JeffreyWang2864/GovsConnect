//
//  AppDelegate.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        AppIOManager.shared.establishConnection()
        self.registerForPushNotifications()
        AppDataManager.shared.setupData()
        //设置window的跟控制器为标签栏控制器
        self.window = UIWindow.init(frame:UIScreen.main.bounds)
        let tabbarVc = GCTabBarViewController()
        self.window?.rootViewController = tabbarVc
        self.window?.backgroundColor = UIColor.white
        IQKeyboardManager.sharedManager().enableAutoToolbar = false
        IQKeyboardManager.sharedManager().enable = true
        
        //launch screen animation
        let welcomeVC = WelcomeViewController()
        self.window!.rootViewController!.view.addSubview(welcomeVC.view)
        welcomeVC.view.frame = UIScreen.main.bounds
        DispatchQueue.main.asyncAfter(deadline: .now() + 3){
            UIView.animate(withDuration: 0.5, animations: {
                welcomeVC.view.alpha = 0
            }) { (completion) in
                welcomeVC.dismiss(animated: false, completion: nil)
                welcomeVC.view.removeFromSuperview()
            }
        }

        
        
        
//        let remoteNotifications = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
//        if remoteNotifications != nil{
//           let dict = remoteNotifications as! Dictionary<String, Any>
//            let aps = dict["aps"] as! Dictionary<String, Any>
//            let alertMessage = aps["alert"] as! String
//            let newRemoteNotificationElement = RemoteNotificationContainer(alertMessage, 0)
//            AppDataManager.shared.remoteNotificationData.insert(newRemoteNotificationElement, at: 0)
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//                NotificationCenter.default.post(Notification.init(name: NotificationViewController.didReceivedNotificationName))
//            }
//        }
        return true
    }
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
            print("Permission granted: \(granted)")
            
            guard granted else {
                NSLog("permission not granted")
                return
            }
            self.getNotificationSettings()
        }
    }
    
    func getNotificationSettings(){
        UNUserNotificationCenter.current().getNotificationSettings { (settings) in
            guard settings.authorizationStatus == .authorized else {
                NSLog("not authorized")
                return
            }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
        }
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let tokenParts = deviceToken.map { data -> String in
            return String(format: "%02.2hhx", data)
        }
        
        let token = tokenParts.joined()
        AppIOManager.shared.deviceToken = token
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        makeMessageViaAlert(title: "Failed to register remote notification", message: error.localizedDescription)
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        print(userInfo)
//        let apsDict = userInfo["aps"] as! Dictionary<String, AnyObject>
//        let alertMessage = apsDict["alert"] as! String
//        let newRemoteNotificationElement = RemoteNotificationContainer(alertMessage, 0)
//        AppDataManager.shared.remoteNotificationData.insert(newRemoteNotificationElement, at: 0)
//        NotificationCenter.default.post(Notification.init(name: NotificationViewController.didReceivedNotificationName))
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
        UIApplication.shared.applicationIconBadgeNumber = 0
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

