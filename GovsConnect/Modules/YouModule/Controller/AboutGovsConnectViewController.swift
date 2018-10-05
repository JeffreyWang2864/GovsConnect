//
//  AboutGovsConnectViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/4.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class AboutGovsConnectViewController: UIViewController {
    @IBOutlet var logoImageView: UIImageView!
    @IBOutlet var termAndServiceButton: UIButton!
    @IBOutlet var privacyPolicyButton: UIButton!
    @IBOutlet var officialWebsiteButton: UIButton!
    @IBOutlet var rateButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = "About"
        self.logoImageView.image = UIImage.init(named: "govs_connect_app_logo_1024@1x.png")
        self.logoImageView.layer.cornerRadius = 0.15 * self.logoImageView.width
        self.logoImageView.clipsToBounds = true
        self.termAndServiceButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.privacyPolicyButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.officialWebsiteButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        self.rateButton.setTitleColor(APP_THEME_COLOR, for: .normal)
        // Do any additional setup after loading the view.
    }
}
