//
//  GCNavigationViewController.swift
//  GovsConnect
//
//  Created by Spring on 2018/6/20.
//  Copyright © 2018年 Eagersoft. All rights reserved.
//  导航控制器

import UIKit

class GCNavigationViewController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 20, weight: .bold), NSAttributedStringKey.foregroundColor: UIColor.white]
    }

    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
//        if(self.viewControllers.count > 0){
//            viewController.hidesBottomBarWhenPushed = true
//        }
        super.pushViewController(viewController, animated: animated)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }

}
