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
    var loginView: GCLoginViewController? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
             self.loginView = GCLoginViewController.init(nibName: "GCLoginViewController", bundle: Bundle.main)
        }
        self.loginView!.view.frame = self.view.bounds
        self.present(self.loginView!, animated: true) {
            //code here
        }
    }
}
