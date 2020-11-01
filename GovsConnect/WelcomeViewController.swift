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
        self.view.backgroundColor = .white
        //self.welcomeLabel.alpha = 0
        self.welcomeLabel.textColor = APP_THEME_COLOR
        let c = welcomeImageView.constraints[0]
        c.constant = screenWidth / 12 * 16
        self.appImageView.layer.cornerRadius = 10
        self.welcomeImageView.layer.cornerRadius = 20
//        UIView.animate(withDuration: 0.5, animations: {
//            self.welcomeLabel.alpha = 1
//            }, completion: { (returnFlag) in
//                UIView.animate(withDuration: 1.5){
//                    self.welcomeLabel.alpha = 0
//                }
//        })
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
