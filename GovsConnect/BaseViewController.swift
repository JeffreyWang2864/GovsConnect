//
//  BaseViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet var navigationBarTitle: UINavigationItem!
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var postsTabBarItem: UITabBarItem!
    var postsViewController: PostsViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.postsViewController = PostsViewController(nibName: "PostsViewController", bundle: nil)
        
        let contentViewY: CGFloat = 64
        let contentViewHeight = self.view.bounds.height - self.tabBar.bounds.height - 64
        self.postsViewController!.view.frame = CGRect(x: self.view.bounds.origin.x, y: contentViewY, width: self.view.bounds.width, height: contentViewHeight)
        self.view.addSubview(self.postsViewController!.view)
        let vc = WelcomeViewController(nibName: "WelcomeViewController", bundle: nil)
        self.view.addSubview(vc.view)
        vc.view.frame = vc.view.superview!.bounds
        UIView.animate(withDuration: 0.5, delay: 3, options: .curveEaseInOut, animations: {
            vc.view.alpha = 0
        }) { (returnFlag) in
            vc.view.removeFromSuperview()
        }
        self.tabBar.delegate = self
        self.tabBar.selectedItem = self.postsTabBarItem
        self.navigationBarTitle.title = self.postsTabBarItem.title!
        self.view.backgroundColor = UIColor.init(red: 0.757, green: 0.243, blue: 0.314, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}

extension BaseViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        self.navigationBarTitle.title = item.title!
    }
}
