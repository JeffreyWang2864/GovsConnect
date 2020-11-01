//
//  WelcomeViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    @IBOutlet var welcomeLabel: UILabel!
    @IBOutlet var welcomeImageView: UIImageView!
    @IBOutlet var appImageView: UIImageView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.appImageView.layer.cornerRadius = 10
        switch PHONE_TYPE {
        case .iphone8, .iphone8plus, .ipodtouch:
            let c = welcomeImageView.constraints[0]
            c.constant = screenWidth / 11 * 13
        default:
            let c = welcomeImageView.constraints[0]
            c.constant = screenWidth / 11 * 14
            let d = self.view.constraints[5]
            d.constant = 60
        }
        
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
