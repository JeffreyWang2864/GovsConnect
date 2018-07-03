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
            let url = URL(string: "https://www.google.com")!
            let vc = UIViewController()
            vc.view.frame = self.view.bounds
            let webv = UIWebView()
            vc.view.addSubview(webv)
            webv.frame = vc.view.bounds
            self.navigationController!.pushViewController(vc, animated: true)
            vc.navigationItem.title = "Daily Bulletin"
            webv.loadRequest(URLRequest(url: url))
        case 3:
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
        default:
            NSLog("\(sender.view!.tag)")
        }
    }
}


