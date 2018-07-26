//
//  YouViewController.swift
//  GovsConnect
//
//  Created by Jeffrey Wang on 2018/7/20.
//  Copyright © 2018 Eagersoft. All rights reserved.
//

import UIKit

class YouViewController: UIViewController {
    @IBOutlet var authorImageView: UIImageView!
    @IBOutlet var authorName: UILabel!
    @IBOutlet var tableView: UITableView!
    @IBOutlet var backgroundView: UIVisualEffectView!
    private var userDetailVC: UserDetailViewController!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.backgroundView.backgroundColor = APP_BACKGROUND_GREY
        let data = AppDataManager.shared.users[AppDataManager.shared.currentPersonID]!
        self.authorImageView.layer.cornerRadius = self.authorImageView.width / 2
        self.backgroundView.layer.cornerRadius = 15
        self.backgroundView.clipsToBounds = true
        self.authorImageView.image = UIImage.init(named: data.profilePictureName)
        self.authorImageView.contentMode = .scaleAspectFit
        self.authorImageView.clipsToBounds = true
        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "YOU_SETTING_TABLEVIEW_CELL")
        self.authorName.text = data.name
        self.authorName.numberOfLines = 0
        self.tableView.backgroundColor = APP_BACKGROUND_ULTRA_GREY
        self.tableView.delegate = self
        self.tableView.dataSource = self
        let tgr = UITapGestureRecognizer(target: self, action: #selector(self.goToMyProfile(_:)))
        self.backgroundView.addGestureRecognizer(tgr)
        // Do any additional setup after loading the view.
    }
    
    @objc func goToMyProfile(_ sender: UITapGestureRecognizer){
        self.userDetailVC = UserDetailViewController.init(nibName: "UserDetailViewController", bundle: Bundle.main)
        self.userDetailVC.view.frame = self.view.bounds
        self.userDetailVC.uid = AppDataManager.shared.currentPersonID
        self.userDetailVC.navigationItem.setRightBarButton(UIBarButtonItem(image: UIImage(named: "system_edit"), style: .plain, target: self, action: #selector(self.editingProfile(_:))), animated: false)
        self.navigationController!.pushViewController(self.userDetailVC, animated: true)
    }
    
    @objc func editingProfile(_ sender: UIBarButtonItem){
        let vc = EditProfileViewController()
        vc.view.frame = self.view.bounds
        vc.editProfileCompleteBlock = {
            self.userDetailVC.allowedInformation.removeAll()
            self.userDetailVC.tableView.reloadData()
        }
        self.navigationController!.pushViewController(vc, animated: true)
    }
}

extension YouViewController: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 4
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
        default:
            fatalError()
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
}
