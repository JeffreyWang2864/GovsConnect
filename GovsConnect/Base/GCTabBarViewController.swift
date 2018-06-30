//
//  GCTabBarViewController.swift
//  GovsConnect
//
//  Created by Spring on 2018/6/20.
//  Copyright © 2018年 Eagersoft. All rights reserved.
//  项目的标签栏控制器

import UIKit

class GCTabBarViewController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:UIColorFromRGB(rgbValue: 0xBABABA, alpha: 1)], for: .normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor:APP_THEME_COLOR], for: .selected)
        
        //给标签栏控制器添加子控制器
        let postVc = PostsViewController(nibName: "PostsViewController", bundle: nil)
        self.addChildController(childVc: postVc, title: "Posts", imageName: "", selImage: "")
        
        //发现控制器
        let disVc = DiscoverViewController()
        self.addChildController(childVc: disVc, title: "Discover", imageName: "", selImage: "")
        
        //服务
        let servicesVc = GCServicesViewController()
        self.addChildController(childVc: servicesVc, title: "Services", imageName: "", selImage: "")
        
        //lookUp
        let lookUpVc = GCLookUpViewController()
        self.addChildController(childVc: lookUpVc, title: "look Up", imageName: "", selImage: "")
        
        //You
        let youVc = GCYouViewController()
        self.addChildController(childVc: youVc, title: "you", imageName: "", selImage: "")
    }

    func addChildController(childVc:UIViewController, title:String, imageName:String, selImage:String) -> Void {
        childVc.title = title
        childVc.tabBarItem.image = UIImage.init(named: imageName)
        childVc.tabBarItem.selectedImage = UIImage.init(named: selImage)?.withRenderingMode(.alwaysOriginal)
        let nav = GCNavigationViewController.init(rootViewController: childVc)
        nav.navigationBar.barStyle = .default
        nav.navigationBar.barTintColor = APP_THEME_COLOR
        nav.navigationBar.tintColor = UIColor.white
        nav.navigationBar.isTranslucent = false
        self.addChildViewController(nav)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
