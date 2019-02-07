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
    @IBOutlet var fuckingVersion: UILabel!
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
        self.fuckingVersion.text = APP_CURRENT_VERSION
        // Do any additional setup after loading the view.
        
        switch PHONE_TYPE{
        case .iphone5:
            self.view.constraints[2].constant = 30
        default:
            self.view.constraints[2].constant = 100
        }
    }
    
    @IBAction func termAndServiceButtonDidClick(_ button: UIButton){
        let url = URL(string: "https://www.eagersoft.net/govs-connect-terms-of-services")!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func privacyPolicyButtonDidClick(_ button: UIButton){
        let url = URL(string: "https://www.eagersoft.net/govs-connect-privacy-policy")!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func officialWebsiteButtonDidClick(_ button: UIButton){
        let url = URL(string: "https://www.eagersoft.net/govs-connect")!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
    
    @IBAction func rateAppButtonDidClick(_ button: UIButton){
        let url = URL(string: "itms-apps:itunes.apple.com/us/app/apple-store/id\(APP_ID)?mt=8&action=write-review")!
        if UIApplication.shared.canOpenURL(url){
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
