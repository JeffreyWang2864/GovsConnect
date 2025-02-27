//
//  LinksCollectionViewCell.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/10/4.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class LinksCollectionViewCell: UICollectionViewCell {
    @IBOutlet var titleLabel: UILabel!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var linkButton: UIButton!
    var data: DiscoverLinksDataCountainer?{
        didSet{
            self.titleLabel.text = self.data!.title
            self.descriptionLabel.text = self.data!.description
            self.descriptionLabel.sizeToFit()
            switch self.data!.linkType{
            case .instagram:
                self.linkButton.setImage(UIImage.init(named: "system_instagram_icon.png"), for: .normal)
            case .snapchat:
                self.linkButton.setImage(UIImage.init(named: "system_snapchat_icon.png"), for: .normal)
            case .website:
               self.linkButton.setImage(UIImage.init(named: "system_website_icon.png"), for: .normal)
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = APP_BACKGROUND_LIGHT_GREY
        self.layer.cornerRadius = 15
        self.clipsToBounds = true
        self.linkButton.layer.cornerRadius = 15
        self.linkButton.clipsToBounds = true
        // Initialization code
    }
    
    func didClickOnCell(){
        switch self.data!.linkType{
        case .instagram:
            self.openInstagramLink()
        case .snapchat:
            self.openSnapchatLink()
        case .website:
            self.openWebsiteLink()
        }
    }
    
    func openInstagramLink(){
        let instaUrl = URL(string: self.data!.link)!
        if UIApplication.shared.canOpenURL(instaUrl){
            UIApplication.shared.open(instaUrl, options: [:], completionHandler: nil)
        }else{
            let alert = UIAlertController(title: "Instagram app not found", message: "We are trying to direct you to the \(self.data!.title) Instagram Page, but it seems you don't have Instagram on your device.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Download Instagram", style: .default, handler: { (alertAction) in
                let instaAppUrl = URL(string: "itms-apps://itunes.apple.com/us/app/instagram/id389801252?mt=8")!
                if UIApplication.shared.canOpenURL(instaAppUrl){
                    UIApplication.shared.open(instaAppUrl, options: [:], completionHandler: nil)
                }else{
                    makeMessageViaAlert(title: "Unable to open Instagram on App Store", message: "please try again later")
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            UIApplication.shared.keyWindow!.rootViewController!.present(alert, animated: true, completion: nil)
        }
    }
    
    func openSnapchatLink(){
        
    }
    
    func openWebsiteLink(){
        
    }
}
