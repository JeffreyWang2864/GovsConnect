//
//  BaseViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/6/7.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class BaseViewController: UIViewController {
    @IBOutlet var tabBar: UITabBar!
    @IBOutlet var postsTabBarItem: UITabBarItem!
    static let presentPostsDetailNotificationName = Notification.Name.init("presentPostsDetailNotificationName")
    var postsViewController: PostsViewController?
    var defaultNavigationController: UINavigationController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNotification()
        self.setupView()
        self.beginPreparingAnimation()
    }
    
    func setupNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(self.presentPostsDetail(_:)), name: BaseViewController.presentPostsDetailNotificationName, object: nil)
    }
    
    func setupView(){
        self.postsViewController = PostsViewController(nibName: "PostsViewController", bundle: nil)
        self.defaultNavigationController = UINavigationController(rootViewController: self.postsViewController!)
        self.view.addSubview(self.defaultNavigationController!.view)
        let contentViewHeight = self.view.bounds.height - self.tabBar.bounds.height
        self.defaultNavigationController!.view.frame = CGRect(x: self.view.bounds.origin.x, y: self.view.bounds.origin.y, width: self.view.bounds.width, height: contentViewHeight)
        self.defaultNavigationController!.navigationBar.barStyle = .default
        self.defaultNavigationController!.navigationBar.barTintColor = APP_THEME_COLOR
        self.defaultNavigationController!.navigationBar.isTranslucent = false
        self.defaultNavigationController!.navigationBar.topItem!.title = "Posts"
        self.defaultNavigationController!.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedStringKey.foregroundColor: UIColor.white]
        self.tabBar.selectedItem = self.postsTabBarItem
    }
    
    func beginPreparingAnimation(){
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
        self.view.backgroundColor = UIColor.init(red: 0.757, green: 0.243, blue: 0.314, alpha: 1.0)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    private func setupBasicViewTransation(){
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        transition.timingFunction = CAMediaTimingFunction(name:kCAMediaTimingFunctionEaseInEaseOut)
        self.view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    @objc func presentPostsDetail(_ sender: Notification){
        let selectedTag = sender.userInfo!["indexPath"] as! Int
        self.setupBasicViewTransation()
        let detailViewController = PostsDetailViewController(nibName: "PostsDetailViewController", bundle: Bundle.main)
        detailViewController.correspondTag = selectedTag
        self.defaultNavigationController!.pushViewController(detailViewController, animated: false)
    }
}

extension BaseViewController: UITabBarDelegate{
    func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
        NSLog("switch tab")
    }
}
