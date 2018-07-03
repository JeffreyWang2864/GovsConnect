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
        default:
            NSLog("\(sender.view!.tag)")
        }
    }
}


