//
//  YouViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/20.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit
import GoogleSignIn

class YouViewController: UIViewController {
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIVisualEffectView!
    private var userDetailVC: UserDetailViewController!
    var loginViewController: GCLoginRequireViewController?
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = APP_BACKGROUND_GREY
        self.authorImageView.layer.cornerRadius = self.authorImageView.width / 2
        self.backgroundView.layer.cornerRadius = 15
        self.backgroundView.clipsToBounds = true
        self.authorImageView.contentMode = .scaleAspectFit
        self.authorImageView.clipsToBounds = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "YOU_SETTING_TABLEVIEW_CELL")
        self.authorName.numberOfLines = 0
        self.tableView.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.goToMyProfile(_:)))
        self.backgroundView.addGestureRecognizer(tgr)
        self.loginViewController = GCLoginRequireViewController.init(nibName: "GCLoginRequireViewController", bundle: Bundle.main)
        self.loginViewController!.view.frame = self.view.bounds
        if !AppIOManager.shared.isLogedIn{
            self.view.addSubview(self.loginViewController!.view)
            return
        }
        let data = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!
        self.authorName.text = data.name
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        guard AppDataManager.shared.currentPersonID != "" else{
            return
        }
        let data = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!
        let imgData = AppDataManager.shared.profileImageData[data.uid]!
        self.authorImageView.image = UIImage.init(data: imgData)!
    }
    
    @objc func loginAction(_ sender: Notification){
        if AppIOManager.shared.isLogedIn{
            guard self.loginViewController != nil else{
                return
            }
            if self.loginViewController!.loginView != nil{
                self.loginViewController!.loginView!.dismiss(animated: false) {
                    //code
                }
            }
            if self.loginViewController!.isThatYouView != nil{
                self.loginViewController!.isThatYouView!.dismiss(animated: false) {
                    //code
                }
            }
            let data = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!
            self.authorName.text = data.name
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.loginViewController!.view.removeFromSuperview()
            }
        }
        //log out
        self.view.addSubview(self.loginViewController!.view)
        self.loginViewController!.view.frame = self.view.bounds
    }
    
    @objc func goToMyProfile(_ sender: UITapGestureRecognizer){
        self.userDetailVC = UserDetailViewController.init(nibName: "UserDetailViewController", bundle: Bundle.main)
        self.userDetailVC.view.frame = self.view.bounds
        self.userDetailVC.uid = AppDataManager.shared.currentPersonID
        self.userDetailVC.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "system_edit"), style: .plain, target: self, action: #selector(self.editingProfile(_:))), animated: false)
        self.navigationController!.pushViewController(self.userDetailVC, animated: true)
    }
    
    @objc func editingProfile(_ sender: UIBarButtonItem){
//        let vc = EditProfileViewController()
//        vc.view.frame = self.view.bounds
//        vc.editProfileCompleteBlock = {
//            self.userDetailVC.allowedInformation.removeAll()
//            self.userDetailVC.tableView.reloadData()
//        }
//        self.navigationController!.pushViewController(vc, animated: true)
        
        
        let vc = NewEditProfileViewController()
        vc.view.frame = self.view.bounds
        vc.data = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!
        vc.didChangeProfileBlock = {
            NotificationCenter.default.post(Notification(name: PostsViewController.shouldRealRefreashCellNotificationName))
            let _ = self.navigationController!.popViewController(animated: true)
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension YouViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 5
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 9.9
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 0.1
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "YOU_SETTING_TABLEVIEW_CELL", for: indexPath)
        cell.textLabel!.textColor = APP_THEME_COLOR
        switch indexPath.section{
        case 0:
            cell.textLabel!.text = "manage my posts"
        case 1:
            cell.textLabel!.text = "settings"
        case 2:
            cell.textLabel!.text = "about Govs Connect"
        case 3:
            cell.textLabel!.text = "give us a feedback"
        case 4:
            cell.textLabel!.text = "log out"
        default:
            fatalError()
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.section {
        case 0:
            //manage my posts
            let vc = ManagePostsViewController()
            vc.view.frame = self.view.bounds
            self.navigationController!.pushViewController(vc, animated: true)
        case 1:
            //setting
            let vc = SettingViewController()
            vc.view.frame = self.view.bounds
            self.navigationController!.pushViewController(vc, animated: true)
        case 2:
            //about govs connect
            makeMessageViaAlert(title: "Page not available for alpha version", message: "\"about govs connect\" page is not available for alpha version")
        case 3:
            //give us feedback
            makeMessageViaAlert(title: "Page not available for alpha version", message: "\"give us feedback\" page is not available for alpha version")
        case 4:
            //log out
            let alert = UIAlertController(title: "By clicking \"Log out\" below, you will not be able to view, post, reply, or like any post as \(AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!.name), and you will not have the access to the \"Look up\" section.", message: nil, preferredStyle: .actionSheet)
            alert.addAction(UIAlertAction(title: "Log out", style: .destructive, handler: { (alert) in
                AppIOManager.shared.logOut(){ isSuccessful -> Void in
                    GIDSignIn.sharedInstance().signOut()
                    assert(AppDataManager.shared.currentPersonID != "")
                    AppDataManager.shared.currentPersonID = ""
                    NotificationCenter.default.post(Notification(name: AppIOManager.loginActionNotificationName))
                }
            }))
            alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (alert) in
                //code
            }))
            self.navigationController!.present(alert, animated: true, completion: nil)
        default:
            fatalError()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
