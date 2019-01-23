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
import GoogleSignIn
import Google

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, GIDSignInDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        self.handleLaunchOption(launchOptions)
        GIDSignIn.sharedInstance().clientID = "861370252489-8rckqjp8n6bk4d782a7j52a0tk00b7kj.apps.googleusercontent.com"
        GIDSignIn.sharedInstance().delegate = self
        AppIOManager.shared.establishConnection()
        AppDataManager.shared.setupData()
        self.registerForPushNotifications()
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
        return true
    }
    
    func handleLaunchOption(_ launchOptions: [UIApplicationLaunchOptionsKey: Any]?){
//        let remoteNotifications = launchOptions?[UIApplicationLaunchOptionsKey.remoteNotification]
//        if remoteNotifications != nil{
//            let dict = remoteNotifications as! Dictionary<String, Any>
//            let aps = dict["aps"] as! Dictionary<String, Any>
//            let alertMessage = aps["alert"] as! String
//            switch alertMessage{
//            case "Weekend events for the new week is available. Check it out!":
//                let allEvents = AppPersistenceManager.shared.fetchObject(with: .event)
//                for event in allEvents{
//                    AppPersistenceManager.shared.deleteObject(of: .event, with: event)
//                }
//            default:
//                break
//            }
//        }
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

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        NSLog("\(userInfo)")
        let apsDict = userInfo["aps"] as! Dictionary<String, AnyObject>
        let alertMessage = apsDict["alert"] as! String
        if alertMessage == "Weekend events for the new week is available. Check it out!"{
            let allEvents = AppPersistenceManager.shared.fetchObject(with: .event)
            for event in allEvents{
                AppPersistenceManager.shared.deleteObject(of: .event, with: event)
            }
            if application.applicationState != .inactive{

            }
            completionHandler(.newData)
            return
        }
        completionHandler(.noData)
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
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        AppPersistenceManager.shared.saveContext()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance().handle(url as URL?,
                                                 sourceApplication: options[UIApplication.OpenURLOptionsKey.sourceApplication] as? String,
                                                 annotation: options[UIApplication.OpenURLOptionsKey.annotation])
    }
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!,
              withError error: Error!) {
        if let error = error {
            print("\(error.localizedDescription)")
        } else {
            // Perform any operations on signed in user here.
            let userId = user.userID// For client-side use only!
            let idToken = user.authentication.idToken // Safe to send to the server
            let fullName = user.profile.name
            let email = user.profile.email!.lowercased()
            guard email.suffix(from: email.firstIndex(of: "@")!) == "@govsacademy.org" else{
                makeMessageViaAlert(title: "Please login with a Govs email", message: "The login was successful, but please login with your Governor's Academy email(*@govsacademy.org).")
                GIDSignIn.sharedInstance().signOut()
                return
            }
            let uid = AppDataManager.shared.findUserBy(email: email)
            guard uid != nil else{
                makeMessageViaAlert(title: "Email not found", message: "\(email) does not appear in our database. Please contact the developer")
                return
            }
            NotificationCenter.default.post(name: GCLoginRequireViewController.displayIsThatYouNotificationName, object: nil, userInfo: ["uid": uid!])
        }
    }
    
    // Stop the UIActivityIndicatorView animation that was started when the user
    // pressed the Sign In button
    func sign(_ signIn: GIDSignIn!, didDisconnectWith user: GIDGoogleUser!,
              withError error: Error!) {
        makeMessageViaAlert(title: "Sign in to Google Error", message: error.localizedDescription)
    }
}

