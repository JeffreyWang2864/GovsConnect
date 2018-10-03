//
//  DiscoverViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/29.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController {
    @IBOutlet var mainView: GCWaterfallScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.mainView.frame = self.view.bounds
        self.mainView.cellHeight = UIScreen.main.bounds.size.height / 7 * 3
        for i in stride(from: 0, to: AppDataManager.shared.discoverData.count, by: 1) {
            let v = DiscoverBasicCellView()
            v.data = AppDataManager.shared.discoverData[i]
            let gr = UITapGestureRecognizer(target: self, action: #selector(self.didClickOnDiscoverFunction(_:)))
            v.tag = i
            v.addGestureRecognizer(gr)
            self.mainView.cells.append(v)
        }
        self.mainView.arrangeCells()
        // Do any additional setup after loading the view.
    }
    
    @objc func didClickOnDiscoverFunction(_ sender: UITapGestureRecognizer){
        switch sender.view!.tag{
        case 0:
            // weekend event
            let vc = WeekendDetailViewController.init(nibName: "WeekendDetailViewController", bundle: Bundle.main)
            self.navigationController!.pushViewController(vc, animated: true)
        case 1:
            //daily bulletin
            let url = URL(string: "https://docs.google.com/document/d/1cZ7nb44a26OWvgOJWlY0CklBrDaPb248wJ9ozgXROKI/edit")!
            let vc = UIViewController()
            vc.view.frame = self.view.bounds
            let webv = UIWebView()
            vc.view.addSubview(webv)
            webv.frame = vc.view.bounds
            self.navigationController!.pushViewController(vc, animated: true)
            vc.navigationItem.title = "Daily Bulletin"
            webv.loadRequest(URLRequest(url: url))
        case 2:
            //govs trade
            let instaUrl = URL(string: "instagram://user?username=govstrade")!
            if UIApplication.shared.canOpenURL(instaUrl){
                UIApplication.shared.open(instaUrl, options: [:], completionHandler: nil)
            }else{
                let alert = UIAlertController(title: "Instagram app not found", message: "We are trying to direct you to the Govs Trade Instagram Page, but it seems you don't have Instagram on your device.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Download Instagram", style: .default, handler: { (alertAction) in
                    let instaAppUrl = URL(string: "itms-apps://itunes.apple.com/us/app/instagram/id389801252?mt=8")!
                    if UIApplication.shared.canOpenURL(instaAppUrl){
                        UIApplication.shared.open(instaAppUrl, options: [:], completionHandler: nil)
                    }else{
                        let a = UIAlertController(title: "Unable to open Instagram on App Store", message: nil, preferredStyle: .alert)
                        a.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                        self.present(a, animated: true, completion: nil)
                    }
                }))
                alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
        case 3:
            //rate your food
            guard AppIOManager.shared.connectionStatus != .none else{
                let alert = UIAlertController(title: "Sorry, you cannot rate foods on offline mode:(", message: "Your device is not connecting to the Internet.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: nil))
                self.navigationController!.present(alert, animated: true, completion: nil)
                return
            }
            let vc = RateYourFoodViewController.init(nibName: "RateYourFoodViewController", bundle: Bundle.main)
            self.navigationController!.pushViewController(vc, animated: true)
        case 4:
            //more
            let vc = UIViewController()
            vc.view.frame = self.view.bounds
            vc.view.backgroundColor = APP_BACKGROUND_ULTRA_GREY
            vc.navigationItem.title = "More..."
            
            let cardBackgroundWidthOffset: CGFloat = {
                switch PHONE_TYPE{
                case .iphone5:
                    return 60
                case .iphone6:
                    return 60
                case .iphone6plus, .iphonexr:
                    return 50
                case .iphonex:
                    return 50
                case .iphonexsmax:
                    return 50
                }
            }()
            let cardBackgroundHeightOffset: CGFloat = {
                switch PHONE_TYPE{
                case .iphone5:
                    return 45
                case .iphone6:
                    return 95
                case .iphone6plus, .iphonexr:
                    return 95
                case .iphonex:
                    return 95
                case .iphonexsmax:
                    return 95
                }
            }()
            let cardBackgroundFontSize: CGFloat = {
                switch PHONE_TYPE{
                case .iphone5:
                    return 14
                case .iphone6:
                    return 16
                case .iphone6plus, .iphonexr:
                    return 18
                case .iphonex:
                    return 18
                case .iphonexsmax:
                    return 18
                }
            }()
            
            let cardBackgroundView = UIView(frame: CGRect(x: 25, y: 25, width: screenWidth - cardBackgroundWidthOffset, height: vc.view.frame.size.height - cardBackgroundHeightOffset))
            cardBackgroundView.backgroundColor = UIColor.white
            cardBackgroundView.layer.cornerRadius = 20
            let titleLabel = UILabel(frame: CGRect(x: 10, y: 20, width: screenWidth - 50 - 20, height: 60))
            titleLabel.font = UIFont.systemFont(ofSize: 22, weight: .bold)
            titleLabel.text = "Want to add a new discovery page?"
            titleLabel.textAlignment = .center
            titleLabel.numberOfLines = 0
            
            let descriptionLabel = UILabel(frame: CGRect(x: 10, y: 90, width: screenWidth - 50 - 20, height: cardBackgroundView.frame.size.height - 90 - 20))
            descriptionLabel.font = UIFont.systemFont(ofSize: cardBackgroundFontSize, weight: .regular)
            descriptionLabel.text = "    The Govs Connect crew always encourages users to publish their own discovery page. We promote pages that bring conveniences and benefits to our community. Please contact us without hesitation once you got an idea. However, publishing something public to the entire school should not be taken lightly. A review of your application between faculty and developers is necessary. Accepted applications are supposed to have a high “market requirement”, which can solve issues from (or bring advantages to) the majorities. More importantly, your application must adhere to the school rules. Once you have your idea ready, you may throw your message to the developer email(dev@govs.app). You may also talk with us in person. We cannot wait to hear your idea!"
            descriptionLabel.numberOfLines = 0
            descriptionLabel.sizeToFit()
            cardBackgroundView.addSubview(titleLabel)
            cardBackgroundView.addSubview(descriptionLabel)
            vc.view.addSubview(cardBackgroundView)
            self.navigationController!.pushViewController(vc, animated: true)
        default:
            NSLog("\(sender.view!.tag)")
        }
    }
}
