//
//  GCLoginRequireViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/8/29.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class GCLoginRequireViewController: UIViewController {
    @IBOutlet var imageView: UIImageView!
    static let displayIsThatYouNotificationName = Notification.Name("displayIsThatYouNotificationName")
    var loginView: GCGoogleLoginViewController? = nil
    var isThatYouView: IsThisYouViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentIsThisYouView(_:)), name: GCLoginRequireViewController.displayIsThatYouNotificationName, object: nil)
        let c = self.view.constraints[0]
        if PHONE_TYPE == .iphone5{
            c.constant = 40
            self.imageView.constraints[0].constant = 92
            self.imageView.constraints[1].constant = 92
            self.imageView.layer.cornerRadius = 92 / 2
        }
        self.view.backgroundColor = APP_BACKGROUND_GREY
        if PHONE_TYPE != .iphone5{
            self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        }
        self.imageView.clipsToBounds = true
        self.imageView.layer.borderColor = APP_THEME_COLOR.cgColor
        self.imageView.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonDidClick(){
        if self.loginView == nil{
             self.loginView = GCGoogleLoginViewController.init(nibName: "GCGoogleLoginViewController", bundle: Bundle.main)
        }
        self.loginView!.view.frame = self.view.bounds
        self.present(self.loginView!, animated: true) {
            //code here
        }
    }
    
    @objc func presentIsThisYouView(_ sender: Notification){
        let uid = sender.userInfo!["uid"] as! String
        if self.isThatYouView == nil{
            self.isThatYouView = IsThisYouViewController.init(nibName: "IsThisYouViewController", bundle: Bundle.main)
        }
        self.isThatYouView!.view.frame = self.view.bounds
        self.isThatYouView!.uid = uid
        self.present(self.isThatYouView!, animated: true) {
            //code here
        }
    }
}
