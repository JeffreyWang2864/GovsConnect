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
        self.view.backgroundColor = APP_BACKGROUND_GREY
        self.imageView.layer.cornerRadius = self.imageView.frame.width / 2
        self.imageView.clipsToBounds = true
        self.imageView.layer.borderColor = APP_THEME_COLOR.cgColor
        self.imageView.layer.borderWidth = 2
        // Do any additional setup after loading the view.
    }
    
    @IBAction func loginButtonDidClick(){
        self.loginView = GCLoginViewController.init(nibName: "GCLoginViewController", bundle: Bundle.main)
        self.loginView!.view.frame = self.view.bounds
        self.present(self.loginView!, animated: true) {
            //code here
        }
    }
}
